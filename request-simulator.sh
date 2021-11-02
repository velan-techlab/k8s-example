#!/bin/sh

while true;
do
	#curl http://micro-world.com/A; echo; sleep  0.5;
	#curl http://micro-world.com/B; echo;  sleep 0.5;
	#curl http://micro-world.com/C; echo;  sleep 0.5;
	#curl http://micro-world.com/AB; echo; sleep 0.5; 
	#curl http://micro-world.com/AC; echo; sleep 0.5;
	#curl http://micro-world.com/BA; echo; sleep 0.5;
	#curl http://micro-world.com/BC; echo; sleep 0.5;
	#curl http://micro-world.com/CA; echo; sleep 0.5;
	#curl http://micro-world.com/CB; echo; sleep 0.5;
	curl http://micro-world.com/ABC; echo; sleep 0.5;
	#curl http://micro-world.com/ACB; echo; sleep 0.5;
	#curl http://micro-world.com/CBA; echo; sleep 0.5;
	#curl http://micro-world.com/CAB; echo; sleep 0.5;
	#curl http://micro-world.com/BAC; echo; sleep 0.5;
	#curl http://micro-world.com/BCA; echo; sleep 0.5;
	curl -H "x-env-is-test-user:yes" http://micro-world.com/ABC; echo; sleep 0.5;

done;
