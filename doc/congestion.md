#Congestion Control

* [First Loss](#first-loss)
* [Slow Start](#slow-start)
  * [Standard](#standard)
  * [ACK Train Length](#ack-train-length)
  * [Delay Increase](#delay-increase)
  * [Abort](#abort)
* [Cong Avoid](#cong-avoid)
  * [Epoch Phase](#epoch-phase)
  * [Epoch Point](#epoch-point)
* [Advanced CC](#advanced-cc)

## First Loss ##

**fl_phase**    
The first loss occurs in which phase, slow start or congestion avoid. The value is {ss|cong}.

**fl_cwnd**    
The congestion window size when first loss happens. The unit is MSS.

**fl_rtt**    
The RTT when first loss happens. The unit is ms.

## Slow Start ##

There are three kinds of slow start algorithms used by Cubic.
- Standard
- ACK Train Length
- Delay Increase

Besides, when slow start quits due to loss or connection close, we call it Abort.

#### STANDARD ####

**std_ss_cnt**    
The number of completed Standard slow start.

**std_ss_time**    
Average time of Standard slow start. The unit is RTT.

**std_start_cwnd**    
Average start cwnd of Standard slow start. The unit is MSS.

**std_end_cwnd**    
Average end cwnd of Standard slow start. The unit is MSS.

#### ACK TRAIN LENGTH ####

**ack_ss_cnt**    
The number of completed ACK Train Length slow start.

**ack_ss_time**    
Average time of ACK Train Length slow start. The unit is RTT.

**ack_start_cwnd**    
Average start cwnd of ACK Train Length slow start. The unit is MSS.

**ack_end_cwnd**    
Average end cwnd of ACK Train Length slow start. The unit is MSS.

#### DELAY INCREASE ####

**delay_ss_cnt**    
The number of completed Delay Increase slow start.

**delay_ss_time**    
Average time of Delay Increase slow start. The unit is RTT.

**delay_start_cwnd**    
Average start cwnd of Delay Increase slow start. The unit is MSS.

**delay_end_cwnd**    
Average end cwnd of Delay Increase slow start. The unit is MSS.

#### ABORT ####

**abort_ss_cnt**    
The number of unfinished slow start.

**abort_ss_time**    
Average time of Abort slow start. The unit is RTT.

**abort_start_cwnd**  
Average start cwnd of Abort slow start. The unit is MSS.

**abort_end_cwnd**    
Average end cwnd of Abort slow start. The unit is MSS.

## Cong Avoid ##

Cubic uses a cubic function of the elapsed time from the last congestion event.
The region between two continuous congestion events is called an epoch. So actually 
the congestion avoidance of Cubic is composed by serveral epochs.

#### EPOCH PHASE ####

An epoch period consists of three phases:
- Searching phase, ramps up to the window size before the last congestion event.
- Stable phase, allows the window size to stabilize for a period.
- Max probing phase, probes for more bandwidth.

**epoch_cnt**       
The number of epochs experienced by a connection.

**epoch_time**    
Total time of epochs. The unit is RTT.

**search_cnt**    
The number of searching phases experienced by a connnection.

**search_time**    
Total time of searching phases. The unit is RTT.

**probe_cnt**    
The number of probing phases experienced by a connection.

**probe_time**    
Total time of probing phases. The unit is RTT.

#### EPOCH POINT ####

**ep_start_cnt**    
The number of epochs' start points.

**ep_start_cwnd**    
Average cwnd of epochs' start points.

**ep_start_rtt**    
Average RTT of epochs' start points.

**ep_steady_cnt**    
The number of epochs' steady points.

**ep_steady_cwnd**    
Average cwnd of epochs' steady points.

**ep_steady_rtt**    
Average RTT of epochs' steady points.

**ep_end_cnt**    
The number of epochs' end points.

**ep_end_cwnd**    
Average cwnd of epochs' end points.

**ep_end_rtt**    
Average RTT of epochs' end points.

## Advanced CC ##

Tcpdive uses five kinds of critical points to depict the fluctuation of a connection.
A critial point looks like:

    [point] DATE local remote id cwnd rtt time msg

**point**    
The name of a critical point.
- SS start, enter slow start.
- SS end, exit slow start.
- EP start, start point of an epoch.
- EP steady, stable point of an epoch.
- EP end, end point of an epoch.

**DATE**   
year/month/day

**local**    
DIP:DPORT, ip and port of the server.

**remote**    
SIP:SPORT, ip and port of the client.

**id**    
ISN of the server.

**cwnd**    
Congestion window size, the unit is MSS.

**rtt**    
Round trip time, the unit is ms.

**time**    
Time elapsed from the establishment of a connection, the unit is ms.

**msg**    
The messages conveyed by a critical point.
- null, nothing.
- std, use Standard slow start.
- ack, use ACK Train Length slow start.
- delay, use Delay Increase slow start.
- abort, slow start aborts.
- close, the connection is closing.
- search, in searching phase of an epoch.
- probe, in probing phase of an epoch.

