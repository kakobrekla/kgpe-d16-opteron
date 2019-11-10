Original script taken from https://github.com/lm-sensors/lm-sensors/blob/master/prog/pwm/fancontrol
You may find it as such in `/usr/sbin/fancontrol` if you install lm-sensors (inc. pwmconfig, fancontrol).

Problem:

KGPE-D16 has two modes of fan control: 
- two channels if one is set PWM and other is Voltage Control
- a single channel if configured for all fan headers to be PWM controlled

Not only VC provides worse fan control than PWM, VC can (and does) introduce additional audible noise, therefore we control all (9 large and super quiet ("be-quiet silent wings 3" runing at ~300-600 rpm)) fans via single channel, based on temperature reading of both CPU temperatures.

Patch:

- in fancontol we have a new function `UpdateVirtualTempSensor` which takes two temp sensor inputs `temp7_input` and `temp8_input`, upon which a custom transformation can be applied -- in our case we use `max(temp1, temp2)`. Resulting value is fed in a file in `/tmp/temp0`.

- in configuration file we point the temperature source as `FCTEMPS=hwmon1/device/pwm1=../../../tmp/temp0` which tricks `fancontrol` to read temperature from our custom file instead of single sensor `/sys/class/hwmon/hwmon1/device/temp7_input`.


Notes:

```
cat /etc/modules

...
# Chip drivers
w83627ehf
w83795
```