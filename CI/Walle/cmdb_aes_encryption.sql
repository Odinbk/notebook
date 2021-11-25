CREATE TABLE aes_encryption (
    id INT NOT NULL PRIMARY KEY,
    cluster_id INT,
    cluster_prefix VARCHAR(256),
    main_category_prefix VARCHAR(128),
    business_services_id INT,
    aes_key VARCHAR(256),
    aes_iv VARCHAR(256),
    game_mod VARCHAR(256),
    is_del VARCHAR(256),
    update_user VARCHAR(256),
    update_time VARCHAR(256),
)


CREATE TABLE `aes_encryption` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `cluster_id` int(11) NOT NULL COMMENT '集群id',
  `cluster_prefix` varchar(20) NOT NULL DEFAULT '' COMMENT '集群简称',
  `main_category_prefix` varchar(20) NOT NULL DEFAULT '' COMMENT '游戏简称',
  `business_services_id` int(11) NOT NULL COMMENT '模块id',
  `game_mod` varchar(11) NOT NULL DEFAULT '' COMMENT '模块简称',
  `is_del` tinyint(2) NOT NULL DEFAULT '0' COMMENT '是否已删除： 1 是 0 否',
  `update_user` varchar(30) NOT NULL DEFAULT '' COMMENT '更新人',
  `update_time` int(11) NOT NULL COMMENT '更新时间',
  `aes_key` varchar(32) NOT NULL DEFAULT '' COMMENT 'AES Key',
  `aes_iv` varchar(32) NOT NULL DEFAULT '' COMMENT 'AES IV',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC



curl -X "POST" "http://127.0.0.1:8000/service.json"
-H "Content-Type: application/json"
-H "Date: 2014-12-04T14:38:31+08:00"
-H "Authorization: SERVICE abcdefgh:00e5dbdb4f5134b7e9710b64c37664ac"
-d $'{
    "jsonrpc": "2.0",
    "id":"1",
    "method": "getClusters",
    "params": {
      "name": "集群one",
      "fields":["name","prefix","is_monitor","idc_id","partner_id"]
     }
}'
