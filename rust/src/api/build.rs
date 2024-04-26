use std::collections::HashMap;

use opendal::Operator;

use super::cloud_service::CloudService;

impl CloudService {
    pub(crate) async fn build_s3(config: HashMap<String, String>) -> Operator {
        let mut builder = opendal::services::S3::default();
        builder.root(config.get("root").unwrap());
        builder.bucket(config.get("bucket").unwrap());
        builder.endpoint(config.get("endpoint").unwrap());
        builder.access_key_id(config.get("access_key_id").unwrap());
        builder.secret_access_key(config.get("secret_access_key").unwrap());
        builder.region(config.get("region").unwrap());
        Operator::new(builder).unwrap().finish()
    }

    pub(crate) async fn build_azblob(config: HashMap<String, String>) -> Operator {
        let mut builder = opendal::services::Azblob::default();
        builder.root(config.get("root").unwrap());
        builder.container(config.get("container").unwrap());
        builder.endpoint(config.get("endpoint").unwrap());
        builder.account_name(config.get("account_name").unwrap());
        builder.account_key(config.get("account_key").unwrap());
        Operator::new(builder).unwrap().finish()
    }

    pub(crate) async fn build_azdls(config: HashMap<String, String>) -> Operator {
        let mut builder = opendal::services::Azdls::default();
        builder.root(config.get("root").unwrap());
        builder.filesystem(config.get("filesystem").unwrap());
        builder.endpoint(config.get("endpoint").unwrap());
        builder.account_name(config.get("account_name").unwrap());
        builder.account_key(config.get("account_key").unwrap());
        Operator::new(builder).unwrap().finish()
    }

    pub(crate) async fn build_cos(config: HashMap<String, String>) -> Operator {
        let mut builder = opendal::services::Cos::default();
        builder.root(config.get("root").unwrap());
        builder.bucket(config.get("bucket").unwrap());
        builder.endpoint(config.get("endpoint").unwrap());
        builder.secret_id(config.get("secret_id").unwrap());
        builder.secret_key(config.get("secret_key").unwrap());
        Operator::new(builder).unwrap().finish()
    }

    pub(crate) async fn build_oss(config: HashMap<String, String>) -> Operator {
        let mut builder = opendal::services::Oss::default();
        builder.root(config.get("root").unwrap());
        builder.bucket(config.get("bucket").unwrap());
        builder.endpoint(config.get("endpoint").unwrap());
        builder.access_key_id(config.get("access_key_id").unwrap());
        builder.access_key_secret(config.get("access_key_secret").unwrap());
        Operator::new(builder).unwrap().finish()
    }

    pub(crate) async fn build_gcs(config: HashMap<String, String>) -> Operator {
        let mut builder = opendal::services::Gcs::default();
        builder.root(config.get("root").unwrap());
        builder.bucket(config.get("bucket").unwrap());
        builder.credential(config.get("credential").unwrap());
        builder.predefined_acl(config.get("predefined_acl").unwrap());
        builder.default_storage_class(config.get("default_storage_class").unwrap());
        Operator::new(builder).unwrap().finish()
    }
}
