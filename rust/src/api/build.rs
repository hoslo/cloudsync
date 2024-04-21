use std::collections::HashMap;

use opendal::Operator;

use super::cloud_service::CloudService;

impl CloudService {
    pub(crate) async fn build_s3(config: HashMap<String, String>) -> Operator {
        let mut builder = opendal::services::S3::default();
        builder.root(&config.get("root").unwrap());
        builder.bucket(&config.get("bucket").unwrap());
        builder.endpoint(&config.get("endpoint").unwrap());
        builder.access_key_id(&config.get("access_key_id").unwrap());
        builder.secret_access_key(&config.get("secret_access_key").unwrap());
        builder.region(&config.get("region").unwrap());
        let op = Operator::new(builder).unwrap().finish();
        op
    }
}
