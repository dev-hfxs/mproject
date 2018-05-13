/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年5月13日
* @修改人: 
* @修改日期：
* @描述: 
 */
package com.sierotech.mproject.task;

import org.quartz.CronScheduleBuilder;
import org.quartz.JobBuilder;
import org.quartz.JobDetail;
import org.quartz.Scheduler;
import org.quartz.SchedulerException;
import org.quartz.SchedulerFactory;
import org.quartz.Trigger;
import org.quartz.TriggerBuilder;
/**
* @JDK版本: 1.7
* @创建人: lwm
* @创建日期：2018年5月13日
* @功能描述: 任务调度
 */
public class TaskScheduler {
	private static SchedulerFactory schedFact;
	private static Scheduler sched;
	
	public static void init(){
		try {
			sched  =  org.quartz.impl.StdSchedulerFactory.getDefaultScheduler();
			sched.start();
		} catch (SchedulerException e) {
			e.printStackTrace();
		}
	}
	
	public static void addJob(String jobName,String groupName,String cronExp,Class jobClass){
		try{
			JobDetail jobDetail = JobBuilder.newJob(jobClass).withIdentity("job_"+jobName, "group_"+groupName).build();
			CronScheduleBuilder builder = CronScheduleBuilder.cronSchedule(cronExp);
			Trigger trigger=TriggerBuilder.newTrigger().withIdentity("trigger_"+jobName,"triggerGroup_"+groupName).startNow().withSchedule(builder).build();
			 
			sched.scheduleJob(jobDetail, trigger);
		} catch  (Exception e){
            e.printStackTrace();
        }
	}
	
//	public static void main(String[] args){
//		init();
//		addJob("deleteTempFile","mproject","0 59 23 * * ?",FileCleanJob.class);
//	}
}
