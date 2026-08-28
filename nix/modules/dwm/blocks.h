/* Status blocks for the locally patched dwmblocks build. */
static const Block blocks[] = {
	/* icon  command                                                        interval  signal */
	{" ", "pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -1", 2, 1},
	{" ", "brightnessctl -m | cut -d, -f4",                                  2, 2},
	{" ", "printf '%s%%' \"$(cat /sys/class/power_supply/BAT0/capacity)\"",  15, 0},
	{" ", "date '+%d.%m'",                                                  60, 0},
	{" ", "date '+%H:%M  '",                                                 5, 0},
};

static char delim[] = "  ┇  ";
static unsigned int delimLen = 7;
