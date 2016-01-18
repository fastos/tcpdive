#Transmission

* [Conn ID](#conn-id)
* [Basic](#basic)
* [Exception](#exception)
* [Cwnd / SSthresh](#cwnd-ssthresh)
* [RTT / RTO](#rtt-rto)

## Conn ID ##

**date**    
year/month/day

**start**    
hour/minute/second, the time when a connection is established.

**end**    
hour/minute/second, the time when a connection is closed.

**local**    
DIP:DPORT, ip and port of the server.

**remote**    
SIP:SPORT, ip and port of the client.

**id**    
ISN of the server.    

## Basic ##

**data**    
The amount of data sent out by a connection, the unit is Byte.

**time**    
Lifetime of a connection, the unit is millisecond.

**packet**    
The number of packets sent out by a connection.

**synack_rtx**    
The times SYNACK is retransmitted.

**accept_wait**    
Time elapsed between a connection being established and being accepted. The unit is ms.

## Exception ##

**small_swnd**    
How many times when the send window of server is less than MSS.

**zero_awnd**    
How many times when the advertise window of client is zero.

**rst_flag**    
A packet with RST flag set is sent or received by the connection.

**from_state**    
The state of a connection before monitor is finishing.

**to_state**    
The state of a connection after monitor is finished.

## Cwnd / SSthresh ##

**init_cwnd**    
Initial congestion window size, the unit is MSS.

**end_cwnd**    
Final congestion window size, the unit is MSS.

**init_ssthr**    
Initial slow start threshold, the unit is MSS.

**end_ssthr**    
Fina slow start threshold, the unit is MSS.

## RTT / RTO ##

**rtt_avg**    
Average RTT of a connection, the unit is ms.

**rtt_min**    
Minimal RTT of a connection, the unit is ms.

**rtt_max**    
Maximal RTT of a connection, the unit is ms.

**rtt_cnt**    
The number of RTT samples.

**rto_avg**    
Average RTO of a connection, the unit is ms.

**rto_min**    
Minimal RTO of a connection, the unit is ms.

**rto_max**    
Maximal RTO of a connection, the unit is ms.

**rto_cnt**    
The number of RTO samples.

