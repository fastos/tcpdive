#log format

* [Default Format](#default-format)
* [Detailed Format](#detailed-format)
* [Packet-based Message](#packet-based-message)

## DEFAULT FORMAT ##

Each line of log files represents a TCP connection which is profiled by lots of performance indicators. 
Performance indicators in the same line are recorded in "name=value" way, seperated by commas. 
A performance indicator's value can be -1 in case it hasn't been initialized. 

Performance indicators composing a log line are recorded in the following sequence.

**1. Transmission, default**

    date, start, end, local, remote, id,                                              // Conn ID
    data, time, packet, synack_rtx, accept_wait,                                      // Basic
    small_swnd, zero_awnd, rst_flag, from_state, to_state,                            // Exception
    init_cwnd, end_cwnd, init_ssthr, end_ssthr,                                       // Cwnd / SSthresh
    rtt_avg, rtt_min, rtt_max, rtt_cnt,                                               // RTT
    rto_avg, rto_min, rto_max, rto_cnt,                                               // RTO

**2. Loss & Retransmission, -L option**

    fr_ev, fr_repkts, fr_wait, fr_rec, fr_undo,                                       // Fast retransmit
    to_ev, to_repkts, to_wait, to_rec, to_undo,                                       // Timeout

**3. Congestion control, -C option**

First Loss

    fl_phase, fl_cwnd, fl_rtt,                                                        // First Loss
    
    
Slow Start

    std_ss_cnt, std_ss_time, std_start_cwnd, std_end_cwnd,                            // Standard
    ack_ss_cnt, ack_ss_time, ack_start_cwnd, ack_end_cwnd,                            // ACK Train Length
    delay_ss_cnt, delay_ss_time, delay_start_cwnd, delay_end_cwnd,                    // Delay Increase
    abort_ss_cnt, abort_ss_time, abort_start_cwnd, abort_end_cwnd,                    // Abort
    
Congestion Avoidance

    cwnd_unlimit, fast_converg,                                                       
    epoch_cnt, epoch_time, search_cnt, search_time, probe_cnt, probe_time,            // Epoch phase
    ep_start_cnt, ep_start_cwnd, ep_start_rtt,                                        // Start point
    ep_steady_cnt, ep_steady_cwnd, ep_steady_rtt,                                     // Steady point
    ep_end_cnt, ep_end_cwnd, ep_end_rtt,                                              // End point

**4. HTTP information, -H option**

    req_count,                                                                           
    num, time, acked_data, req_wait, resp_wait, trans_time,                           // First pair
    ...
    num, time, acked_data, req_wait, resp_wait, trans_time                            // Last pair

#### EXAMPLE #####

Below is a log line profiling a TCP connection with -L, -C and -H options enabled.

    2015/9/8,start=19:12:09,end=19:12:19,local=10.210.136.54:80,remote=10.210.136.53:19497,id=909432482,
    data=1048830,time=10219,packet=726,synack_rtx=0,accept_wait=1,
    small_swnd=35,zero_awnd=0,rst_flag=0,from_state=FIN_WAIT1,to_state=FIN_WAIT2,
    init_cwnd=10,end_cwnd=5,init_ssthr=2147483647,end_ssthr=93,
    rtt_avg=557,rtt_min=155,rtt_max=976,rtt_cnt=442,
    rto_avg=805,rto_min=416,rto_max=1262,rto_cnt=442,
    fr_ev=-1,fr_repkts=-1,fr_wait=-1,fr_rec=-1,fr_undo=-1,
    to_ev=1,to_repkts=12,to_wait=1577,to_rec=1242,to_undo=0,
    fl_phase=cong,fl_cwnd=133,fl_rtt=939,
    std_ss_cnt=-1,std_ss_time=-1,std_start_cwnd=-1,std_end_cwnd=-1,
    ack_ss_cnt=-1,ack_ss_time=-1,ack_start_cwnd=-1,ack_end_cwnd=-1,
    delay_ss_cnt=1,delay_ss_time=2,delay_start_cwnd=10,delay_end_cwnd=29,
    abort_ss_cnt=-1,abort_ss_time=-1,abort_start_cwnd=-1,abort_end_cwnd=-1,
    cwnd_unlimit=39,fast_converg=0,
    epoch_cnt=1,epoch_time=9,search_cnt=-1,search_time=-1,probe_cnt=1,probe_time=9,
    ep_start_cnt=1,ep_start_cwnd=30,ep_start_rtt=227,
    ep_steady_cnt=-1,ep_steady_cwnd=-1,ep_steady_rtt=-1,
    ep_end_cnt=1,ep_end_cwnd=133,ep_end_rtt=939,
    req_count=1,
    num=1,time=19:12:09,acked_data=1048830,req_wait=0,resp_wait=1,trans_time=10218

## DETAILED FORMAT ##

Besides the default format, a more human readable alternative is provided for realtime analysis, 
which is called detailed format. Instead of a log line, serveral tables are used to describe a TCP connection.

    No.   |   TABLE NAME     |   OPTION    |   WHEN TO DISPLAY
    1     |   TRANS          |   -         |   always                                
    2     |   RTT            |   -         |   always                            
    3     |   RETRANS        |   -L        |   has loss and retransmission  
    4     |   FIRST LOSS     |   -C        |   has loss                           
    5     |   SLOW START     |   -C        |   has slow start                       
    6     |   CONG PHASE     |   -C        |   has congestion avoidance             
    7     |   CONG POINT     |   -C        |   has congestion avoidance            
    8     |   HTTP           |   -H        |   use HTTP protocol                   
    
#### EXAMPLE ONE####

Below is a TCP connection profiled using -L, -C and -H options, with detailed format enabled.

    ==========================================================================
    2015/12/30,start=16:48:55,end=16:48:56,id=890624153
    local=10.210.136.54:8080,remote=10.210.136.53:28686
        
    TRANS TABLE
    data               1048815 B
    time               898 ms
    packet             726 pkts
    synack_rtx         0 pkts
    accept_wait        0 ms
    small_swnd         1
    zero_awnd          0
    rst_flag           0
    from_state         FIN_WAIT1
    to_state           FIN_WAIT2
    init_cwnd          10
    end_cwnd           63
    init_ssthresh      2147483647
    end_ssthresh       29
        
    RTT TABLE          avg        min        max        cnt       
    RTT(ms)            48         8          102        399       
    RTO(ms)            247        201        267        399       
        
    SLOW START TABLE   count      s_cwnd     e_cwnd     time(RTT) 
    Delay Increase     1          10         29         2         
        
    CONG PHASE TABLE   count      time(RTT) 
    epoch              1          13        
    probing            1          13        
        
    CONG POINT TABLE   count      cwnd       rtt       
    start              1          30         17        
    end                1          63         65        
        
    HTTP TABLE         time       ack_data   req_wait   resp_wait  trans_time
    Num.1              16:48:55   1048815    0          0          898       

#### EXAMPLE TWO####

Below is a TCP connection profiled using -L, -C and -H options, with detailed format enabled.

     ==========================================================================
     2015/12/30,start=16:07:31,end=16:07:38,id=1395054193
     local=10.210.136.54:8080,remote=10.210.136.53:60212
     
     TRANS TABLE
     data               234812 B
     time               6367 ms
     packet             163 pkts
     synack_rtx         0 pkts
     accept_wait        4 ms
     small_swnd         36
     zero_awnd          0
     rst_flag           0
     from_state         LAST_ACK
     to_state           CLOSE
     init_cwnd          10
     end_cwnd           11
     init_ssthresh      11
     end_ssthresh       9
     
     RTT TABLE          avg        min        max        cnt       
     RTT(ms)            302        75         456        91        
     RTO(ms)            574        347        698        92        
     
     RETRANS TABLE      events     pkts       wa_time    rec_time   undo       
     Fast recovery      2          8          879        421        0          
     Timeout            1          8          689        958        0          
     TO in Recovery     1          8          689        958        
     
     FIRST LOSS TABLE   phase      cwnd       rtt       
                        cong       17         416       
     
     SLOW START TABLE   count      s_cwnd     e_cwnd     time(RTT) 
     Standard           3          8          10         0         
     
     CONG PHASE TABLE   count      time(RTT) 
     epoch              3          9         
     searching          1          1         
     probing            2          8         
     
     CONG POINT TABLE   count      cwnd       rtt       
     start              3          11         319       
     end                3          13         380       
     
     HTTP TABLE         time       ack_data   req_wait   resp_wait  trans_time
     Num.1              16:07:31   218884     7          5          6115      

## Packet-based Message ##

Although most of log messages are based on connection, there are some based on packet.

**Monitor Reset Packet, -R option**

    [TX RST], DATE, local, remote                                      // Active RST sent
    [RX RST], DATE, local, remote, state                               // RST received

Below are some examples.

    [TX RST],2015/9/8,19:12:10,local=10.210.136.54:80,remote=10.210.136.53:19450
    [RX RST],2015/9/8,19:20:09,local=10.210.136.54:80,remote=10.210.136.53:14678,state=CLOSE_WAIT

**Advanced Congestion Control, -A option**

    [point], DATE, local, remote, id, cwnd, rtt, time, msg             // Critical point

Below are some critical points by the use of which we can depict the fluctuation of a connection.

    [SS start],2015/9/8,19:12:09,local=10.210.136.54:80,remote=10.210.136.53:19497,id=909432482,cwnd=10,rtt=140,time=156,msg=null
    [SS end],2015/9/8,19:12:09,local=10.210.136.54:80,remote=10.210.136.53:19497,id=909432482,cwnd=30,rtt=227,time=407,msg=delay
    [EP start],2015/9/8,19:12:09,local=10.210.136.54:80,remote=10.210.136.53:19497,id=909432482,cwnd=30,rtt=227,time=407,msg=probe
    [EP end],2015/9/8,19:12:18,local=10.210.136.54:80,remote=10.210.136.53:19497,id=909432482,cwnd=133,rtt=939,time=8977,msg=probe
    [SS start],2015/9/8,19:12:18,local=10.210.136.54:80,remote=10.210.136.53:19497,id=909432482,cwnd=2,rtt=784,time=9535,msg=null
    [SS end],2015/9/8,19:12:19,local=10.210.136.54:80,remote=10.210.136.53:19497,id=909432482,cwnd=5,rtt=459,time=10219,msg=close
    
    
