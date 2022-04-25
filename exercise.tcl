set ns [new Simulator]
$ns rtproto DV
set nf [open out.nam w]
$ns namtrace-all $nf
set f [open out.tr w]
$ns trace-all $f

proc finish {} {
	global ns f nf
	$ns flush-trace
	close $f
	close $nf
	exec nam out.nam &
	exit 0
}

set N 6
for {set i 0} {$i < $N} {incr i} {
	set n($i) [$ns node]
}

$ns duplex-link $n(0) $n(1) 2Mb 10ms DropTail
$ns duplex-link $n(1) $n(2) 2Mb 10ms DropTail
$ns duplex-link $n(2) $n(3) 2Mb 10ms DropTail
$ns duplex-link $n(3) $n(4) 2Mb 10ms DropTail
$ns duplex-link $n(4) $n(0) 2Mb 10ms DropTail
$ns duplex-link $n(1) $n(5) 2Mb 10ms DropTail

set udp0 [new Agent/UDP]
$ns attach-agent $n(0) $udp0

set cbr0 [new Agent/CBR]
$ns attach-agent $n(0) $cbr0
$cbr0 set packetSize_ 500
$cbr0 set interval_ 0.005
set tcp1 [new Agent/TCP]
$ns attach-agent $n(1) $tcp1

set null0 [new Agent/Null]
$ns attach-agent $n(5) $null0

set sink1 [new Agent/TCPSink]
$ns attach-agent $n(5) $sink1

$ns connect $cbr0 $null0

$ns at 0.5 "$cbr0 start"
$ns rtmodel-at 1.0 down $n(0) $n(1)
$ns rtmodel-at 2.0 up $n(0) $n(1)
$ns at 4.5 "$cbr0 stop"
$ns at 5.0 "finish"
$ns run
