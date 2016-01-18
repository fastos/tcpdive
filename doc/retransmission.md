#Loss and Retransmission

* [Fast retransmit](#fast-retransmit)
* [Timeout](#timeout)

## Fast retransmit ##

**fr_ev**    
The number of Fast retransmit events occurred during the lifetime of a connection.

**fr_repkts**    
The number of packets retransmitted during Fast retransmit events.

**fr_wait**    
The wait time of Fast retransmit events.

**fr_rec**    
The recovery time of Fast retransmit events.

**fr_undo**    
The supurious times of Fast retransmit events.

## Timeout ##

**to_ev**    
The number of Timeout events occurred during the lifetime of a connection.

**to_repkts**    
The number of packets retransmitted during Timeout events.

**to_wait**    
The wait time of Timeout events.

**to_rec**    
The recovery time of Timeout events.

**to_undo**    
The supurious times of Timeout events.

Furthermore, we classify Timeout events according to the congestion state during which they happen.
- Open
- Disorder
- CWR
- Recovery
- Loss

