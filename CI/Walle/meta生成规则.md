"WORLD_SERVER:9.150.61.181:10200":{
    "GUILD":{
      "8203-8203":["guild"]
    },
    "GVE_KYOUTOU":{
      "8203-8203":["ShadalooUnusual","ShadalooAttack"]
    },
    "GVE_TEAM_SINGLE":{
      "8203-8203":["BreakThrough","ChallengeBook","HorcruxDungeon"]
    },
    "GVE_KYOUTOU_SINGLE":{
      "8203-8203":["ShadalooUnusual","ShadalooAttack"]
    },
    "HALL":{
      "8203-8203":["hall"]
    },
    "GVE_TEAM":{
      "8203-8203":["BreakThrough","ChallengeBook","HorcruxDungeon"]
    },
    "GLOBAL_HALL":{
      "*":["1-9999"]
    },
    "MATCH":{
      "8203-8203":["GASP","WORLD_ARENA"]
    },
    "BASE":{
      "8203-8203":["BASE"]
    }
  }
  
  以现在的配置为例说明
  
  从外到内key分别是
  
  业务
  分区范围
  子业务
  
  
  业务配置的考虑项
  
  1.是否全区共用一台机器
  2.如果是多区共用一台机器，多少个分区用一台机器，由压测数据预估出
  3.是否必须在一台单独的机器上
  4.同一种业务是否需要多台服务器支撑，例如，gve，会将gve的不同地图分配到不同的机器上，子业务的配置就是配置这个的