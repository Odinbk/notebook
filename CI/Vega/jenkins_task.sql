CREATE TABLE jenkins_task (
    job_id INT NOT NULL PRIMARY KEY,
    task_id INT,
    task_url VARCHAR(256),
    task_name VARCHAR(128),
    task_status TINYINT,
    start_time DATETIME, 设置默认值,
    end_time DATETIME,
    task_details JSON,
)