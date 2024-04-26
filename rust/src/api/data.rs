use anyhow::{anyhow, Result};
use log::{info, LevelFilter};
use sqlx::{sqlite::SqlitePoolOptions, Pool, Sqlite};
use tokio::sync::OnceCell;

use super::cloud_service::init_cloud_service;

static DB_POOL: OnceCell<Pool<Sqlite>> = OnceCell::const_new();

flutter_logger::flutter_logger_init!(LevelFilter::Info);

pub async fn new_database(db_url: String) -> Result<()> {
    let _ = DB_POOL
        .get_or_try_init(|| async {
            info!("Connecting to database: {}", db_url);
            let pool = SqlitePoolOptions::new()
                .max_connections(5)
                .connect(&db_url)
                .await?;
            let result: Result<Pool<Sqlite>> = Ok(pool);
            result
        })
        .await?;
    create_table().await?;
    init_cloud_service().await?;
    Ok(())
}

pub(crate) async fn create_table() -> Result<()> {
    let _ = sqlx::query(
        r#"
            CREATE TABLE IF NOT EXISTS configs (
                id INTEGER PRIMARY KEY AUTOINCREMENT, -- 主键
                name TEXT,  -- 名称
                service_type TEXT, -- 服务类型
                config TEXT,   -- 服务配置
                current INTEGER -- 当前选中服务, 1 为选中
            )"#,
    )
    .execute(get_db_pool().await.unwrap())
    .await?;
    Ok(())
}

pub(crate) async fn get_db_pool() -> Result<&'static Pool<Sqlite>> {
    DB_POOL
        .get()
        .ok_or_else(|| anyhow!("Database pool not initialized"))
}
