use std::collections::HashMap;

use anyhow::{anyhow, Result};

use super::{
    cloud_service::{build_cloud_service, change_cloud_service, CloudService},
    data::get_db_pool,
};

#[derive(Debug, Clone, sqlx::Type)]
#[sqlx(type_name = "service_type")]
pub enum ServiceType {
    S3,
    Azblob,
    Azdls,
    Cos,
    Oss,
    Gcs,
}

#[derive(Debug)]
pub struct Config {
    pub id: i64,
    pub name: String,
    pub service_type: ServiceType,
    pub config: HashMap<String, String>,
    pub current: i32,
}

#[derive(Debug, sqlx::FromRow)]
pub struct DatabaseConfig {
    pub id: i64,
    pub name: String,
    pub service_type: ServiceType,
    pub config: sqlx::types::Json<HashMap<String, String>>,
    pub current: i32,
}

impl From<&DatabaseConfig> for Config {
    fn from(db_config: &DatabaseConfig) -> Self {
        Config {
            id: db_config.id,
            name: db_config.name.clone(),
            service_type: db_config.service_type.clone(),
            config: db_config.config.0.clone(),
            current: db_config.current,
        }
    }
}

impl From<&Config> for DatabaseConfig {
    fn from(config: &Config) -> Self {
        DatabaseConfig {
            id: config.id,
            name: config.name.clone(),
            service_type: config.service_type.clone(),
            config: sqlx::types::Json(config.config.clone()),
            current: config.current,
        }
    }
}

impl Config {
    pub async fn new(
        name: String,
        service_type: ServiceType,
        config: HashMap<String, String>,
    ) -> Result<Self> {
        let mut config = Config {
            id: 0,
            name: name,
            service_type: service_type,
            config: config,
            current: 0,
        };
        config.id = config.create_config().await?;
        Ok(config)
    }

    pub(crate) async fn get_current_config() -> Result<Option<Config>> {
        let config: Option<DatabaseConfig> =
            sqlx::query_as("SELECT * FROM configs WHERE current = 1")
                .fetch_optional(get_db_pool().await?)
                .await?;

        Ok(config.map(|c| (&c).into()))
    }

    pub async fn change_current_config(id: i64) -> Result<()> {
        sqlx::query(
            r#"
        UPDATE configs SET current = 0 WHERE current = 1;
        UPDATE configs SET current = 1 WHERE id = $1;
        "#,
        )
        .bind(id)
        .execute(get_db_pool().await?)
        .await?;
        change_cloud_service(id).await?;
        Ok(())
    }

    pub async fn list_configs() -> Result<Vec<Self>> {
        let configs: Vec<DatabaseConfig> = sqlx::query_as("SELECT * FROM configs")
            .fetch_all(get_db_pool().await?)
            .await
            .map_err(|err| anyhow!("Failed to list configs, error: {}", err))?;
        Ok(configs.iter().map(|c| c.into()).collect())
    }

    async fn create_config(&self) -> Result<i64> {
        let database_config: DatabaseConfig = self.into();
        let r = sqlx::query(
            r#"
            INSERT INTO configs (name, service_type, config, current) VALUES ($1, $2, $3, 0)
        "#,
        )
        .bind(&database_config.name)
        .bind(&database_config.service_type)
        .bind(&database_config.config)
        .execute(get_db_pool().await?)
        .await
        .map_err(|err| anyhow!("Failed to create config, error: {}", err))?;

        Ok(r.last_insert_rowid())
    }

    pub(crate) async fn get_config(id: i64) -> Result<Self> {
        let config: DatabaseConfig = sqlx::query_as(
            r#"
            SELECT * FROM configs WHERE id = $1
        "#,
        )
        .bind(id)
        .fetch_one(get_db_pool().await?)
        .await
        .map_err(|err| anyhow!("Failed to get config, error: {}", err))?;
        Ok((&config).into())
    }

    pub async fn delete_config(id: i64) -> Result<()> {
        sqlx::query("DELETE FROM configs WHERE id = $1")
            .bind(id)
            .execute(get_db_pool().await?)
            .await?;
        Ok(())
    }
}

#[derive(Clone, Debug)]
pub struct Entry {
    pub path: String,
    pub mode: EntryMode,
    pub content_length: u64,
    pub content_type: Option<String>,
    pub last_modified: Option<i64>,
}

#[derive(Clone, Debug)]
pub enum EntryMode {
    FILE,
    DIR,
    Unknown,
}

impl From<opendal::EntryMode> for EntryMode {
    fn from(value: opendal::EntryMode) -> Self {
        match value {
            opendal::EntryMode::FILE => EntryMode::FILE,
            opendal::EntryMode::DIR => EntryMode::DIR,
            opendal::EntryMode::Unknown => EntryMode::Unknown,
        }
    }
}

impl From<&opendal::Entry> for Entry {
    fn from(item: &opendal::Entry) -> Self {
        Entry {
            path: item.path().to_string(),
            mode: item.metadata().mode().into(),
            content_length: item.metadata().content_length(),
            content_type: item.metadata().content_type().map(|ct| ct.to_string()),
            last_modified: item.metadata().last_modified().map(|ts| ts.timestamp()),
        }
    }
}
