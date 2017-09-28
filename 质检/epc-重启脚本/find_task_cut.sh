#!/bin/bash
function find_task_cut()
{
  #å®šä¹‰æ–‡ä»¶å¤´  
  file_head="DHXX_pingan_0_"
  #touch_time=$(date +%Y%m%d --date '1 days ago')
  #event_time=`date "+%Y-%m-%d %H:%M:%S"`
  #æ‹¼å‡ºä¸€ä¸ªä¸Žäºšä¿¡åŒåçš„æ–‡ä»¶
  myFile=$file_head${touch_time}0001_$touch_time.txt
  #å®šä¹‰æ–‡ä»¶æ–‡ä»¶å‘½åè§„åˆ™æ•°ç»„
  count_array=(00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 64 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99)
  #å®šä¹‰ç©ºçš„æ–‡ä»¶åå±žç»„  #å®šä¹‰åˆ†å‰²æ–‡ä»¶å¤§å°
  cut_num=1500
  #åˆ¤æ–­æŽ¢æµ‹æ–‡ä»¶æ˜¯å¦å­˜åœ¨
  if [ -f "/home/cti/$myFile" ]; then
    echo "$event_time: find new task file $myFile" >>  /home/cti/monitor_cut.log
    find_flag=1
    #å¤åˆ¶æ–‡ä»¶å¤¹åˆ°ä¸´æ—¶ç¼“å­˜ç›®å½•tmp_task
    cp  /home/cti/$myFile  /home/cti/2017/tmp_task/
    #ç§»åŠ¨æ–‡ä»¶å¤¹åˆ°å¤‡ä»½ç›®å½•
    mv  /home/cti/$myFile  /home/cti/2017/bak_task/
    #åˆ›å»ºæ“ä½œç›®å½•åŠæŽ¢æµ‹å­æ–‡ä»¶å¤¹  
    mkdir -p /home/cti/2017/tmp_task/$touch_time
    #mkdir -p ./TASK/$touch_time
    mkdir -p /home/cti/TASK/$touch_time
    #ç”Ÿæˆæ‹†åˆ†æ–‡ä»¶
    cd  /home/cti/2017/tmp_task/
    sed -n  '1,1p' $myFile >  /home/cti/2017/tmp_task/tmp_head.txt
    sed -n  '2,$p' $myFile >  /home/cti/2017/tmp_task/tmp_task_begin.txt
    #æ‹†åˆ†æ–‡ä»¶
    for count in `seq 100`
      do
  	  #¶¨ÒåÊÂ¼þÊ±¼ä
          event_time=`date "+%Y-%m-%d %H:%M:%S"`
          #¶¨Òå²ð·ÖºóµÄÎÄ¼þÃû 
	  file_txt_name=$file_head${touch_time}00${count_array[$count]}_$touch_time.txt
          file_new_name=$file_head${touch_time}00${count_array[$count]}_$touch_time.new
    	  #È¡²ð·ÖµÄÎÄ¼þÐÐÊý
    	  tmp_task_num=$(more tmp_task_begin.txt|wc -l)
          echo "$event_time: $tmp_task_num"
    	  #ÅÐ¶Ï²ð·ÖÎÄ¼þµÄÊÇ·ñÐèÒª²ð·Ö
          if [ "$tmp_task_num" -gt "$cut_num" ]&&[ "$count" -le "87" ]; then
    	    #´´½¨²ð·ÖºóµÄÎÄ¼þ
            touch /home/cti/2017/tmp_task/$touch_time/$file_txt_name
            touch /home/cti/2017/tmp_task/$touch_time/$file_new_name
            #Ð´Èë5000ÐÐÊý¾Ýµ½²ð·ÖºóµÄÎÄ¼þ
            head -1  tmp_head.txt > /home/cti/2017/tmp_task/$touch_time/$file_txt_name
            sed  -n  '1,5000p' tmp_task_begin.txt >>  /home/cti/2017/tmp_task/$touch_time/$file_txt_name
          elif [ "$tmp_task_num" -le "$cut_num" ]&&[ "$tmp_task_num" -gt "0" ]; then
      	    #´´½¨²ð·ÖºóµÄÎÄ¼þ
            touch  /home/cti/2017/tmp_task/$touch_time/$file_txt_name
            touch  /home/cti/2017/tmp_task/$touch_time/$file_new_name
      	    #Ð´ÈëÊ£ÓàÐÐÊý¾Ýµ½²ð·ÖºóµÄÎÄ¼þ
            head -1  tmp_head.txt > /home/cti/2017/tmp_task/$touch_time/$file_txt_name
            sed  -n  '1,$p' tmp_task_begin.txt >> /home/cti/2017/tmp_task/$touch_time/$file_txt_name
           # cp  -r ./$touch_time   /home/cti/TASK
          elif [ "$count" -gt "87" ]; then
            echo "´ïµ½×î´ó²ð·ÖÊý13Íò£¬Í£Ö¹²ð·Ö" >>  /home/cti/monitor_cut.log
            break
          else
            echo "$event_time:task file process finish" >>  /home/cti/monitor_cut.log
            break
          fi 
          #ÖØÐÂ¶¨Òå²ð·ÖÎÄ¼þ
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
     #ÇÐ»»µÄisaµÄÄ¿Â¼
     cd /home/iflytek/isakits/bin64
     test_isa_file=1.vox.xml
     #É¾³ý²âÊÔ½á¹ûÎÄ¼þ
     rm -rf 1.vox.xml
     #²âÊÔisa
     sh test_isa.sh  >> /dev/null 
     sleep 2
     if [ -f "./$test_isa_file" ]; then
       echo "$event_time: isa·þÎñÕý³£" >>  /home/cti/monitor_cut.log
       isa_status_return=1
     else
       #ÖÕ½áEPC½ø³Ì
       echo "$event_time: isa·þÎñÒì³£" >> /home/cti/monitor_cut.log
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
#EPC×´Ì¬ÅÐ¶Ï
function epc_status()
{
     #ÇÐ»»µÄEPCµÄÄ¿Â¼
     cd  /home/iflytek/EPC
     count_epc_task=` ls /home/iflytek/EPCTASK/batch/|grep txt|wc -l `
     epc_log=/home/iflytek/EPC/epc.log
     epc_log_stop=`find ${epc_log} -mmin -3|wc -l`
     epc_status_flag=0
     #Èç¹ûEPC´¦ÀíÊý¾ÝÍê³É
     if [ "${count_epc_task}" -eq "0" ]; then
       epc_status_flag=1
       rerurn $count_epc_task
     #Èç¹ûEPCÃ»ÓÐ´¦ÀíÍêÊý¾Ý£¬²¢ÇÒEPCÈÕÖ¾Í£Ö¹´òÓ¡
     elif [ "${count_epc_task}" -ne "0" ]&&[ "${epc_log_stop}" -eq "0" ]; then
       epc_status_flag=0
     #Èç¹ûEPCÃ»ÓÐ´¦ÀíÍêÊý¾Ý£¬²¢ÇÒEPCÈÕÖ¾¼ÌÐøÊä³ö
     else
       #ÅÐ¶Ïisa·þÎñ×´Ì¬
       isa_status
       #echo  $isa_status_return
       #Èç¹ûisa·þÎñÕý³££¬ÈÏÎªEPC×´Ì¬Õý³£·ñÔòÈÏÎªEPC×´Ì¬²»Õý³£
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
          echo "$event_time: É¾³ýÒÑ¾­Íê³ÉµÄÈÎÎñ$task_txt_file" >> /home/cti/monitor_cut.log
        elif [ ! -f "/home/cti/TASK/$touch_time/$task_txt_file" ]&&[ "$count_task_file" -lt "3" ]; then
          cp /home/cti/2017/tmp_task/$touch_time/$task_file.*  /home/cti/TASK/$touch_time/
          cp_task_file=1
          echo "$event_time: Ìí¼ÓÐÂµÄÈÎÎñ$task_txt_file" >> /home/cti/monitor_cut.log
        else
          task_num=1
        fi
      done
  fi
}

while [ true ]; do
  #¶¨ÒåÎÄ¼þÍ·
  touch_time=$(date +%Y%m%d --date '1 days ago')
  event_time=`date "+%Y-%m-%d %H:%M:%S"`
  find_task_cut
  task_rm_cp
  epc_status
  if [ "$epc_status_flag" -eq "1" ]; then
    echo "$event_time:EPC×´Ì¬Õý³££¡£¡£¡" >>  /home/cti/monitor_cut.log
    echo "$event_time: EPC Ä¿Ç°²¢ÐÐÈÎÎñÊýÎª$count_epc_task" >>  /home/cti/monitor_cut.log
  elif [ "$epc_status_flag" -eq "0" ]; then
    #É±ËÀEPC½ø³Ì
    echo "$event_time:EPC×´Ì¬Òì³££¡£¡£¡" >>  /home/cti/monitor_cut.log
    ps -ef|grep 'EPCService'|grep -v 'grep'|awk '{print $2}'|xargs kill -9
    rm -rf /home/iflytek/EPCTASK/batch/DHXX_pingan*
    rm -rf /home/iflytek/EPCTASK/sender/pingan*
    rm -rf /home/iflytek/EPC/epc.log
    rm -rf /home/cti/TASK/$touch_time/*
    echo "$event_time:ÖØÆôEPC" >> /home/cti/monitor_cut.log
    sh   /home/iflytek/EPC/start.sh
  fi
  sleep 300
done
  
