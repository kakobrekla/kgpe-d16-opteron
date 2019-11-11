Original script taken from https://github.com/lm-sensors/lm-sensors/blob/master/prog/pwm/fancontrol
You may find it as such in `/usr/sbin/fancontrol` if you install lm-sensors (inc. pwmconfig, fancontrol).

Problem:

KGPE-D16 has two modes of fan control: 
- two channels if one is set PWM and other is Voltage Control
- a single channel if configured for all fan headers to be PWM controlled

Not only VC provides worse fan control than PWM, VC can (and does) introduce additional audible noise, therefore we control all (9 large and super quiet ("be-quiet silent wings 3" runing at ~300-600 rpm)) fans via single channel, based on temperature reading of both CPU temperatures.

Patch:

- in `fancontol` script we have a new function `UpdateVirtualTempSensor` which takes two temp sensor inputs `temp7_input` and `temp8_input`, upon which a custom transformation can be applied -- in our case we use `max(temp1, temp2)`. Tune the algo to you liking here. Resulting value is written to a file `/tmp/temp0`.

- in fanctonrol configuration file simply point the temperature source to `FCTEMPS=hwmon1/device/pwm1=../../../tmp/temp0` which tricks `fancontrol` to read temperature value (transformed as desired) from the specified file instead of single sensor `/sys/class/hwmon/hwmon1/device/temp7_input` (CPU1) or `/sys/class/hwmon/hwmon1/device/temp8_input` (CPU2).


Notes:

In (my) case coreboot/libreboot does not detect/recognize the sensors when `pwmconfig` is ran, following is the correct config:

```
cat /etc/modules

...
# Chip drivers
w83627ehf
w83795
```