use std::collections::HashMap;

use anyhow::{anyhow, Result};
use flutter_rust_bridge::frb;
use log::info;
use opendal::Metakey;
use tokio::sync::{Mutex, OnceCell};

use super::config::{Config, Entry};

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}

#[frb(opaque)]
pub struct CloudService {
    pub op: opendal::Operator,
    pub config_id: i64,
    pub entries: HashMap<String, Vec<Entry>>,
}

static CLOUD_SERVICE: OnceCell<Mutex<CloudService>> = OnceCell::const_new();

pub(crate) async fn init_cloud_service() -> Result<()> {
    let config = Config::get_current_config().await?;
    match config {
        Some(config) => {
            let r: Result<&Mutex<CloudService>> = CLOUD_SERVICE
                .get_or_try_init(|| async {
                    Ok(Mutex::new(build_cloud_service(config.id).await?))
                })
                .await;
            r?;
            Ok(())
        }
        None => Ok(()),
    }
}

pub(crate) async fn change_cloud_service(id: i64) -> Result<()> {
    info!("111");
    let cs = build_cloud_service(id).await.unwrap();
    match CLOUD_SERVICE.get() {
        Some(cloud_service) => {
            let mut cloud_service = cloud_service.lock().await;
            cloud_service.op = cs.op;
            cloud_service.config_id = id;
            cloud_service.entries = HashMap::new();
            Ok(())
        }
        None => {
            let r: Result<&Mutex<CloudService>> = CLOUD_SERVICE
                .get_or_try_init(|| async { Ok(Mutex::new(cs)) })
                .await;
            r?;
            Ok(())
        }
    }
}

pub(crate) async fn build_cloud_service(id: i64) -> Result<CloudService> {
    let config = Config::get_config(id).await?;

    let op = match config.service_type {
        super::config::ServiceType::S3 => CloudService::build_s3(config.config).await,
        super::config::ServiceType::Azblob => CloudService::build_azblob(config.config).await,
        super::config::ServiceType::Azdls => CloudService::build_azdls(config.config).await,
        super::config::ServiceType::Cos => CloudService::build_cos(config.config).await,
        super::config::ServiceType::Oss => CloudService::build_oss(config.config).await,
        super::config::ServiceType::Gcs => CloudService::build_gcs(config.config).await,
    };

    Ok(CloudService {
        op,
        config_id: id,
        entries: HashMap::new(),
    })
}

fn get_cloud_service() -> Result<&'static Mutex<CloudService>> {
    CLOUD_SERVICE
        .get()
        .ok_or(anyhow!("Cloud service not initialized"))
}

impl CloudService {
    pub async fn clear_cache() -> Result<()> {
        get_cloud_service()?.lock().await.entries.clear();
        Ok(())
    }

    pub async fn list(path: String) -> Result<Vec<Entry>> {
        info!("opendal call {}", path);
        if let Some(entries) = get_cloud_service()?.lock().await.entries.get(&path) {
            info!("cache hit");
            return Ok(entries.clone());
        }
        info!("start call");
        let entries = get_cloud_service()?
            .lock()
            .await
            .op
            .list_with(&path)
            .metakey(Metakey::ContentLength)
            .metakey(Metakey::ContentType)
            .await?;
        info!("entries: {:#?}", entries.len());
        let list = entries.iter().map(|e| e.into()).collect::<Vec<Entry>>();
        get_cloud_service()?
            .lock()
            .await
            .entries
            .insert(path, list.clone());
        Ok(list)
    }

    pub async fn read(path: String) -> Result<Vec<u8>> {
        let bs = get_cloud_service()?.lock().await.op.read(&path).await?;
        Ok(bs)
    }

    pub async fn write(path: String, bs: Vec<u8>) -> Result<()> {
        get_cloud_service()?
            .lock()
            .await
            .op
            .write(&path, bs)
            .await?;
        Ok(())
    }

    pub async fn rename(from: String, to: String) -> Result<()> {
        get_cloud_service()?
            .lock()
            .await
            .op
            .rename(&from, &to)
            .await?;
        Ok(())
    }

    pub async fn copy(from: String, to: String) -> Result<()> {
        get_cloud_service()?
            .lock()
            .await
            .op
            .copy(&from, &to)
            .await?;
        Ok(())
    }
}
