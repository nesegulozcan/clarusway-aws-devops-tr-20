#!/bin/bash
for x in {1..200}
do
        output=$(curl -s http://betul-asg-cfn-19-1548097776.us-east-1.elb.amazonaws.com/ | grep h1)
        echo $x - $output
        sleep 0.5
done
