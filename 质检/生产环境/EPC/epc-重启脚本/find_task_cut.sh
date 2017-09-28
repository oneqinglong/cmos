#!/bin/bash
function find_task_cut()
{
  #定义文件头  
  file_head="DHXX_pingan_0_"
  #touch_time=$(date +%Y%m%d --date '1 days ago')
  #event_time=`date "+%Y-%m-%d %H:%M:%S"`
  #拼出一个与亚信同名的文件
  myFile=$file_head${touch_time}0001_$touch_time.txt
  #定义文件文件命名规则数组
  count_array=(00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 64 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99)
  #定义空的文件名属组  #定义分割文件大小
  cut_num=1500
  #判断探测文件是否存在
  if [ -f "/home/cti/$myFile" ]; then
    echo "$event_time: find new task file $myFile" >>  /home/cti/monitor_cut.log
    find_flag=1
    #复制文件夹到临时缓存目录tmp_task
    cp  /home/cti/$myFile  /home/cti/2017/tmp_task/
    #移动文件夹到备份目录
    mv  /home/cti/$myFile  /home/cti/2017/bak_task/
    #创建操作目录及探测子文件夹  
    mkdir -p /home/cti/2017/tmp_task/$touch_time
    #mkdir -p ./TASK/$touch_time
    mkdir -p /home/cti/TASK/$touch_time
    #生成拆分文件
    cd  /home/cti/2017/tmp_task/
    sed -n  '1,1p' $myFile >  /home/cti/2017/tmp_task/tmp_head.txt
    sed -n  '2,$p' $myFile >  /home/cti/2017/tmp_task/tmp_task_begin.txt
    #拆分文件
    for count in `seq 100`
      do
  	  #�����¼�ʱ��
          event_time=`date "+%Y-%m-%d %H:%M:%S"`
          #�����ֺ���ļ��� 
	  file_txt_name=$file_head${touch_time}00${count_array[$count]}_$touch_time.txt
          file_new_name=$file_head${touch_time}00${count_array[$count]}_$touch_time.new
    	  #ȡ��ֵ��ļ�����
    	  tmp_task_num=$(more tmp_task_begin.txt|wc -l)
          echo "$event_time: $tmp_task_num"
    	  #�жϲ���ļ����Ƿ���Ҫ���
          if [ "$tmp_task_num" -gt "$cut_num" ]&&[ "$count" -le "87" ]; then
    	    #������ֺ���ļ�
            touch /home/cti/2017/tmp_task/$touch_time/$file_txt_name
            touch /home/cti/2017/tmp_task/$touch_time/$file_new_name
            #д��5000�����ݵ���ֺ���ļ�
            head -1  tmp_head.txt > /home/cti/2017/tmp_task/$touch_time/$file_txt_name
            sed  -n  '1,5000p' tmp_task_begin.txt >>  /home/cti/2017/tmp_task/$touch_time/$file_txt_name
          elif [ "$tmp_task_num" -le "$cut_num" ]&&[ "$tmp_task_num" -gt "0" ]; then
      	    #������ֺ���ļ�
            touch  /home/cti/2017/tmp_task/$touch_time/$file_txt_name
            touch  /home/cti/2017/tmp_task/$touch_time/$file_new_name
      	    #д��ʣ�������ݵ���ֺ���ļ�
            head -1  tmp_head.txt > /home/cti/2017/tmp_task/$touch_time/$file_txt_name
            sed  -n  '1,$p' tmp_task_begin.txt >> /home/cti/2017/tmp_task/$touch_time/$file_txt_name
           # cp  -r ./$touch_time   /home/cti/TASK
          elif [ "$count" -gt "87" ]; then
            echo "�ﵽ�������13��ֹͣ���" >>  /home/cti/monitor_cut.log
            break
          else
            echo "$event_time:task file process finish" >>  /home/cti/monitor_cut.log
            break
          fi 
          #���¶������ļ�
          sed -n  '1500,$p' tmp_task_begin.txt > tmp_task_end.txt
          rm -rf tmp_task_begin.txt
          mv tmp_task_end.txt  tmp_task_begin.txt
      done
  else
    echo "$event_time: not find task file" >>  /home/cti/monitor_cut.log
  fi
}

function isa_status()
{
     #�л���isa��Ŀ¼
     cd /home/iflytek/isakits/bin64
     test_isa_file=1.vox.xml
     #ɾ�����Խ���ļ�
     rm -rf 1.vox.xml
     #����isa
     sh test_isa.sh  >> /dev/null 
     sleep 2
     if [ -f "./$test_isa_file" ]; then
       echo "$event_time: isa��������" >>  /home/cti/monitor_cut.log
       isa_status_return=1
     else
       #�ս�EPC����
       echo "$event_time: isa�����쳣" >> /home/cti/monitor_cut.log
        ps -ef|grep 'mtrec'|grep -v 'grep'|awk '{print $2}'|xargs kill -9
       /etc/init.d/srmd stop
       /etc/init.d/sesd stop
       /etc/init.d/spwd stop
       sleep 3
       /etc/init.d/srmd start
       /etc/init.d/sesd start
       /etc/init.d/spwd start
      
       isa_status_return=0
     fi
}
#EPC״̬�ж�
function epc_status()
{
     #�л���EPC��Ŀ¼
     cd  /home/iflytek/EPC
     count_epc_task=` ls /home/iflytek/EPCTASK/batch/|grep txt|wc -l `
     epc_log=/home/iflytek/EPC/epc.log
     epc_log_stop=`find ${epc_log} -mmin -3|wc -l`
     epc_status_flag=0
     #���EPC�����������
     if [ "${count_epc_task}" -eq "0" ]; then
       epc_status_flag=1
       rerurn $count_epc_task
     #���EPCû�д��������ݣ�����EPC��־ֹͣ��ӡ
     elif [ "${count_epc_task}" -ne "0" ]&&[ "${epc_log_stop}" -eq "0" ]; then
       epc_status_flag=0
     #���EPCû�д��������ݣ�����EPC��־�������
     else
       #�ж�isa����״̬
       isa_status
       #echo  $isa_status_return
       #���isa������������ΪEPC״̬����������ΪEPC״̬������
       if [ "${isa_status_return}" -eq "1" ]; then
         epc_status_flag=1
         rerurn ${count_epc_task}
       else
         epc_status_flag=0
       fi
     fi
}

function task_rm_cp()
{
  if [ -d "/home/cti/TASK/$touch_time"  ]; then
    for task_file in /home/cti/2017/tmp_task/$touch_time/*.txt
      do
        rm_task_file=0
        cp_task_file=0
        task_num=0
        count_task_file=`ls /home/cti/TASK/$touch_time/|grep ".txt"|wc -l`
        task_txt_file=${task_file##*/}
        task_file=${task_txt_file%.*}
        task_batch_file=$task_file.path
        middle_result_txt=${task_file:14}
        result_txt=${middle_result_txt:0:12}
        count_result_file=`ls /home/cti/result/success/|grep "$result_txt"|wc -l`
        if [ "$count_result_file" -eq "1" ]; then
          rm -rf /home/cti/2017/tmp_task/$touch_time/$task_file.*
          rm -rf /home/cti/TASK/$touch_time/$task_file.*
          rm_task_file=1
          echo "$event_time: ɾ���Ѿ���ɵ�����$task_txt_file" >> /home/cti/monitor_cut.log
        elif [ ! -f "/home/cti/TASK/$touch_time/$task_txt_file" ]&&[ "$count_task_file" -lt "3" ]; then
          cp /home/cti/2017/tmp_task/$touch_time/$task_file.*  /home/cti/TASK/$touch_time/
          cp_task_file=1
          echo "$event_time: ����µ�����$task_txt_file" >> /home/cti/monitor_cut.log
        else
          task_num=1
        fi
      done
  fi
}

while [ true ]; do
  #�����ļ�ͷ
  touch_time=$(date +%Y%m%d --date '1 days ago')
  event_time=`date "+%Y-%m-%d %H:%M:%S"`
  find_task_cut
  task_rm_cp
  epc_status
  if [ "$epc_status_flag" -eq "1" ]; then
    echo "$event_time:EPC״̬����������" >>  /home/cti/monitor_cut.log
    echo "$event_time: EPC Ŀǰ����������Ϊ$count_epc_task" >>  /home/cti/monitor_cut.log
  elif [ "$epc_status_flag" -eq "0" ]; then
    #ɱ��EPC����
    echo "$event_time:EPC״̬�쳣������" >>  /home/cti/monitor_cut.log
    ps -ef|grep 'EPCService'|grep -v 'grep'|awk '{print $2}'|xargs kill -9
    rm -rf /home/iflytek/EPCTASK/batch/DHXX_pingan*
    rm -rf /home/iflytek/EPCTASK/sender/pingan*
    rm -rf /home/iflytek/EPC/epc.log
    rm -rf /home/cti/TASK/$touch_time/*
    echo "$event_time:����EPC" >> /home/cti/monitor_cut.log
    sh   /home/iflytek/EPC/start.sh
  fi
  sleep 300
done
  
