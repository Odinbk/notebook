1. 把Assets CI从OpenStack虚拟机迁移到Mac打包机，可能需要跑一次全量的Cache。
2. Mtool版本更新不通过容器。获取MTool的版本不通过WallE
3. 移除Assets CI触发钩子限制，统计触发频率，执行速度，等数据。
4. 建辰帮忙准备一个小的Assets仓库。（svn://svn.youle.game/Vega/frontend/Assets_ci）
5. 解除个人TP账号和打包机的关系。评估并发任务数。
6. CI处理先不上传RC，避免污染Cache。

1. 创建MTool Docker镜像，把MTool的tag更新到WallE中。
2. CI脚本通过WallE的接口获取MTool的版本
3. CI任务自己执行的jenkins 节点，通过WallE API获取对应的TP Licence.


TP-ZXZV-C4TQ-LREY-B574
TP-UQER-7KLT-YR99-LP6A

mtl task -i /Users/jenkins/jenkins_home/workspace/vega-Assets-ci/Assets_ci -cd /Users/jenkins/temp/asset_tmp -svn /Users/jenkins/jenkins_home/workspace/vega-Assets-ci/Assets_ci -o /Users/jenkins/temp/assetios/vega_ios_dev_astc/88842 -g vega -t iOS_Astc -sc 88842 -lsc 0 -su wallevega -sp f3ef66b0 -rcu vega@jenkinsrc.youle.game::vega/ -rcp /Users/jenkins/temp/asset_tmp/rc_password/ios/password_file -wj '{"core_upgrade_path": "vega_ios_dev_astc", "upgrade_path": "vega_ios_dev_astc", "os_platform": "ios"}' -sdc /Users/jenkins/temp/asset_tmp/deleted_files.txt -an 'PackupTexture, COPYRES, PackupAnim, CompressTexture, CopyToOutDir'

mtl task -i /Users/jenkins/jenkins_home/workspace/vega-Assets-ci/Assets_ci -cd /Users/jenkins/temp/asset_tmp -svn /Users/jenkins/jenkins_home/workspace/vega-Assets-ci/Assets_ci -o /Users/jenkins/temp/assetios/vega_ios_dev_astc/88842 -g vega -t iOS_Astc -sc 88842 -lsc 0 -su wallevega -sp f3ef66b0 -wj '{"core_upgrade_path": "vega_ios_dev_astc", "upgrade_path": "vega_ios_dev_astc", "os_platform": "ios"}' -sdc /Users/jenkins/temp/asset_tmp/deleted_files.txt -an 'PackupTexture, COPYRES, PackupAnim, CompressTexture, CopyToOutDir'

TexturePacker --algorithm Basic --trim-mode None --sheet /Users/jenkins/temp/assetios/vega_ios_dev_astc/88842/Android/ui/cocosstudio/__res/bgAlpha/bg_arenamatch_1.pvr.ccz --data /Users/jenkins/jenkins_home/workspace/vega-Assets-ci/Assets_ci/ui/cocosstudio/__res/bgAlpha/bg_arenamatch_2_temp.plist --texture-format pvr3ccz --opt ETC1_RGB --etc1-quality high-perceptual /Users/jenkins/jenkins_home/workspace/vega-Assets-ci/Assets_ci/ui/cocosstudio/__res/bgAlpha/bg_arenamatch_2.png --size-constraints AnySize --disable-rotation --border-padding 0 --shape-padding 0 --padding 0 --extrude 0

TexturePacker --algorithm Basic --trim-mode None --sheet /Users/jenkins/temp/assetios/vega_ios_dev_astc/88842/Android/ui/cocosstudio/__res/bgAlpha/bg_arenamatch_2.pvr.ccz --data /Users/jenkins/jenkins_home/workspace/vega-Assets-ci/Assets_ci/ui/cocosstudio/__res/bgAlpha/bg_arenamatch_2_temp.plist --texture-format pvr3ccz --opt ETC1_RGB --etc1-quality high-perceptual /Users/jenkins/jenkins_home/workspace/vega-Assets-ci/Assets_ci/ui/cocosstudio/__res/bgAlpha/bg_arenamatch_2.png --size-constraints AnySize --disable-rotation --border-padding 0 --shape-padding 0 --padding 0 --extrude 0

TexturePacker --algorithm Basic --trim-mode None --sheet /Users/jenkins/temp/assetios/vega_ios_dev_astc/88842/Android/ui/cocosstudio/__res/bgAlpha/bg_arenamatch_3.pvr.ccz --data /Users/jenkins/jenkins_home/workspace/vega-Assets-ci/Assets_ci/ui/cocosstudio/__res/bgAlpha/bg_arenamatch_2_temp.plist --texture-format pvr3ccz --opt ETC1_RGB --etc1-quality high-perceptual /Users/jenkins/jenkins_home/workspace/vega-Assets-ci/Assets_ci/ui/cocosstudio/__res/bgAlpha/bg_arenamatch_2.png --size-constraints AnySize --disable-rotation --border-padding 0 --shape-padding 0 --padding 0 --extrude 0


## 迁移到Mac OS打包机

* 通知项目组暂停Assets CI
* 修改Assets pipeline.py 和 Jenkinsfile, 移除CI对Docker的依赖。移除从WallE中获取MTool tag和licence的代码。修改jenkinsfile中的lable，注释上传资源的代码。
* 调整Jenkins打包机，设置执行Assets CI的机器label和步骤2中一致。
* 解绑一台linux打包机，释放一个licence，vega打包机配置TP，绑定该licence。
* 触发CI，观察产出结果，正确的话重复步骤3，把Vega的打包机都配置好可以执行CI。
* 
* 移除WallE上相关配置，释放Linux打包机。


CREATE TABLE `tp_cache` (
  `res_id` varchar(32) NOT NULL,
  `cache` text,
  PRIMARY KEY (`res_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;A

10 
vega-backend-slave vega-config vega-frontend-slave vega-hotfix-slave

9
vega-assets-slave vega-config vega-frontend-slave vega-slave vega-vegac-slave

8
vega-assets-slave vega-config vega-cd-slave vega-frontend-slave vega-vegac-slave 

12

vega-assets-slave vega-cd-slave vega-backend-slave  vega-frontend-slave vega-vegac-slave


## Licence和机器绑定关系

172.16.170.12
vega_mac_mini_2018_01
硬件 UUID：	95AF9D0B-8097-589A-8292-B4A58E209406
TP Licence: TP-ZXZV-C4TQ-LREY-B574

172.16.170.8
vega_mac_mini_2018_02
硬件 UUID：	D47245B1-9031-57B9-B70B-73336E0CF9D5
TP Licence: TP-ED5C-FZVE-QH6Q-YDH3

172.16.170.9
vega_mac_pro_2013_04
硬件 UUID：	D2E00AE0-9C5B-599D-84B5-190F1F0481BB
TP Licence: TP-T2YJ-Q2Z6-BS19-DMFA

## 没用到的Licence

TP-GL6D-SMR8-H48R-QFSA