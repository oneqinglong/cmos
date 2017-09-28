/*
SQLyog Ultimate v11.27 (32 bit)
MySQL - 5.7.17-log : Database - quality_viedev
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`quality_viedev` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `quality_viedev`;

/*Table structure for table `achieve_status` */

DROP TABLE IF EXISTS `achieve_status`;

CREATE TABLE `achieve_status` (
  `batchId` varchar(255) NOT NULL COMMENT '批次号',
  `fileName` varchar(255) DEFAULT NULL COMMENT '文件名',
  `status` int(2) DEFAULT '0' COMMENT '状态',
  `interfaceType` int(2) DEFAULT NULL COMMENT '接口类型 1为模型预览 0不是',
  `sqlStr` text COMMENT '存储es sql语句',
  `columns` varchar(1000) DEFAULT NULL COMMENT '数据处理维度字段存储',
  `ruleType` int(2) DEFAULT NULL COMMENT '1文本 2静音',
  `toFile` varchar(200) DEFAULT NULL COMMENT 'onest存储地址',
  `detailParser` varchar(1000) DEFAULT NULL COMMENT '二次essql参数',
  `modelId` varchar(64) DEFAULT NULL COMMENT '模型Id',
  PRIMARY KEY (`batchId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `model_detail` */

DROP TABLE IF EXISTS `model_detail`;

CREATE TABLE `model_detail` (
  `FRAGMENT_ID` varchar(255) NOT NULL COMMENT '子模型的Id，亦是主键Id',
  `MODEL_ID` varchar(255) DEFAULT NULL COMMENT '模型Id',
  `PREVIEW_ID` varchar(255) DEFAULT NULL COMMENT '每一次进入页面的ID',
  `TEXT_RULE` longtext COMMENT '规则',
  `RULE_TYPE` decimal(10,0) DEFAULT NULL COMMENT '规则类型,0文本,1过滤,2组合',
  `CREATE_TIME` varchar(255) DEFAULT NULL COMMENT '创建时间',
  `CREATE_TIMESTAMP` decimal(19,0) DEFAULT NULL COMMENT '创建时间',
  `FRAGMENT_NUM` decimal(10,0) DEFAULT NULL COMMENT '片段编号',
  `CHANNEL` decimal(10,0) DEFAULT NULL COMMENT '声道',
  `IS_TAG` decimal(10,0) DEFAULT NULL COMMENT '是否是标签',
  `TAG_CONTENT` longtext COMMENT '标签内容',
  `TAG_TEXT` longtext COMMENT '片段描述內容',
  `TAG_VERSION` longtext COMMENT '片段展示内容',
  `REMARK` varchar(255) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`FRAGMENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `model_filter_result` */

DROP TABLE IF EXISTS `model_filter_result`;

CREATE TABLE `model_filter_result` (
  `id` varchar(255) NOT NULL COMMENT '批次号',
  `modelIds` varchar(255) DEFAULT NULL COMMENT '模型IDS',
  `fileName` varchar(255) NOT NULL,
  `toFile` varchar(255) NOT NULL,
  `status` int(19) NOT NULL DEFAULT '0',
  `state` int(19) NOT NULL DEFAULT '1' COMMENT '0 删除，1 启用',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `model_group` */

DROP TABLE IF EXISTS `model_group`;

CREATE TABLE `model_group` (
  `GROUP_ID` decimal(19,0) NOT NULL,
  `APPLICATION_ID` decimal(19,0) NOT NULL COMMENT '应用id',
  `GROUP_NAME` varchar(255) NOT NULL COMMENT '模型组名称',
  `IS_DISPLAY` decimal(10,0) NOT NULL COMMENT '是否显示（1显示，0隐藏）',
  `DESCRIPTION` varchar(255) DEFAULT NULL COMMENT '描述',
  `DELETED` decimal(10,0) NOT NULL COMMENT '是否删除（1删除，0不删除）',
  `PARENT_ID` decimal(19,0) NOT NULL COMMENT '父级ID',
  `TREE_CODE_NUM` decimal(10,0) NOT NULL COMMENT '当前是第几层',
  `IS_TOPIC` decimal(10,0) DEFAULT NULL COMMENT '是否为专题下的模型组',
  PRIMARY KEY (`GROUP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `model_info` */

DROP TABLE IF EXISTS `model_info`;

CREATE TABLE `model_info` (
  `MODEL_ID` varchar(255) NOT NULL COMMENT 'id',
  `MODEL_NAME` varchar(255) DEFAULT NULL COMMENT '模型名称',
  `MODEL_COMMENT` varchar(255) DEFAULT NULL COMMENT '模型备注',
  `MODEL_TYPE` decimal(10,0) DEFAULT NULL COMMENT '模型类型,0实时1离线',
  `DATASOURCE` varchar(255) DEFAULT NULL COMMENT '数据源',
  `TAG_RULE` varchar(255) DEFAULT NULL COMMENT '标签规则',
  `MODEL_STATUS` decimal(10,0) DEFAULT NULL COMMENT '模型状态模型，状态0启用1停用2删除',
  `USER_ID` decimal(19,0) DEFAULT NULL COMMENT '创建者Id',
  `USER_NAME` varchar(255) DEFAULT NULL COMMENT '创建者用户名',
  `MODIFIER_ID` decimal(19,0) DEFAULT NULL COMMENT '更新者Id',
  `CREATE_TIME` varchar(255) DEFAULT NULL COMMENT '创建时间',
  `UPDATE_TIME` varchar(255) DEFAULT NULL COMMENT '更新时间',
  `RULE_TREE` varchar(255) DEFAULT NULL COMMENT '图形化建模',
  `CHANNEL` decimal(10,0) DEFAULT NULL COMMENT '声道0表示坐席，1表示客户2表示全部',
  `IS_ONLINE` decimal(10,0) DEFAULT NULL COMMENT '是否上线过',
  `OLD_ID` decimal(19,0) DEFAULT NULL COMMENT '更新者Id',
  `MODEL_NUMBER` varchar(255) DEFAULT NULL COMMENT '模型编号',
  `IS_CHANGE` decimal(10,0) DEFAULT NULL COMMENT '是否被修改过',
  `INPUT_RULE` longtext COMMENT '页面上规则的组合',
  `EXTEND1` varchar(255) DEFAULT NULL COMMENT '扩展字段1',
  `EXTEND2` varchar(255) DEFAULT NULL COMMENT '扩展字段2',
  `EXTEND3` varchar(255) DEFAULT NULL COMMENT '扩展字段3',
  `MODIFIER_NAME` varchar(255) DEFAULT NULL COMMENT '更新者用户名',
  `PAGE_TYPE` decimal(10,0) DEFAULT NULL COMMENT '操作页面标示',
  `GROUP_ID` decimal(19,0) DEFAULT NULL COMMENT '模型组',
  `FILTER_RULE` longtext COMMENT '筛选条件Id',
  `TEXT_RULE` longtext COMMENT '文本规则',
  `MODEL_ACCURACY` decimal(10,2) DEFAULT NULL COMMENT '模型准确度',
  `MODEL_UPTONOW` decimal(10,0) DEFAULT NULL COMMENT '模型至今',
  `IS_PASS` decimal(10,0) NOT NULL COMMENT '是否推送质检，1推送，0不推送',
  `MODEL_HITCOUNT` varchar(255) DEFAULT NULL COMMENT '模型命中数',
  `IS_UP` decimal(10,0) NOT NULL COMMENT '是否置顶，1置顶，0没指定',
  `TOTAL_COUNT` varchar(255) DEFAULT NULL COMMENT '数据源下的总数',
  `DATA_LIMIT` longtext COMMENT '数据权限',
  `MODEL_CONDITION` longtext COMMENT '模型上线条件',
  `SILENCE_RULE` longtext COMMENT '静音规则',
  `SPEED_TEXT` longtext COMMENT '解析语速规则',
  `SILENCE_TEXT` longtext COMMENT '解析静音规则',
  `SPEED_RULE` longtext COMMENT '语速规则',
  `ENERGY_RULE` longtext COMMENT '音量规则',
  `ENERGY_TEXT` longtext COMMENT '解析音量规则',
  PRIMARY KEY (`MODEL_ID`),
  KEY `GROUP_ID` (`GROUP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `model_offline_info` */

DROP TABLE IF EXISTS `model_offline_info`;

CREATE TABLE `model_offline_info` (
  `TASK_ID` varchar(255) NOT NULL COMMENT '主键id',
  `MODEL_ID` varchar(255) DEFAULT NULL COMMENT '模型id',
  `MODEL_STATUS` int(11) DEFAULT NULL COMMENT '模型状态',
  `DATASOURCE` varchar(255) DEFAULT NULL COMMENT '数据源',
  `USER_ID` bigint(20) DEFAULT NULL COMMENT '用户id',
  `CREATE_TIME` varchar(255) DEFAULT NULL COMMENT '触发时间',
  PRIMARY KEY (`TASK_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `model_task_t` */

DROP TABLE IF EXISTS `model_task_t`;

CREATE TABLE `model_task_t` (
  `MODEL_ID` varchar(255) NOT NULL,
  `TASK_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`MODEL_ID`,`TASK_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `task_info_t` */

DROP TABLE IF EXISTS `task_info_t`;

CREATE TABLE `task_info_t` (
  `TASK_ID` varchar(255) NOT NULL,
  `TASK_NAME` varchar(255) DEFAULT NULL,
  `TASK_COMMENT` varchar(255) DEFAULT NULL,
  `TASK_TYPE` decimal(19,0) DEFAULT NULL,
  `TASK_STATUS` decimal(19,0) DEFAULT NULL,
  `DATA_SOURCE` varchar(255) DEFAULT NULL,
  `USER_ID` decimal(19,0) DEFAULT NULL,
  `USER_NAME` varchar(255) DEFAULT NULL COMMENT '创建人',
  `MODIFIER_ID` decimal(19,0) DEFAULT NULL,
  `CREATE_TIME` varchar(255) DEFAULT NULL,
  `UPDATE_TIME` varchar(255) DEFAULT NULL,
  `RUN_SCHEMA` decimal(19,0) DEFAULT NULL,
  `RUN_TIME` varchar(255) DEFAULT NULL,
  `FILTER_TYPE` decimal(19,0) DEFAULT NULL,
  `FILTER_CONTENT` longtext,
  `OPERATE_CONTENT` longtext,
  `EXTEND1` varchar(255) DEFAULT NULL,
  `EXTEND2` varchar(255) DEFAULT NULL,
  `FILTE_TYPE` decimal(10,0) DEFAULT NULL,
  `FILTE_CONTENT` longtext,
  PRIMARY KEY (`TASK_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
