# Function to pair or unpair a device based on its connection status
pair_or_unpair_device() {
    local DEVICE_ID="$1"
    blueutil_path=$(which blueutil)
    local res=$($blueutil_path --is-connected $DEVICE_ID)
    if [[ "$res" = '1' ]]; then
        $blueutil_path --unpair $DEVICE_ID
    else
        $blueutil_path --pair $DEVICE_ID
        sleep 1
        $blueutil_path --connect $DEVICE_ID
    fi
}

# Magic Keyboard ID and Magic Trackpad ID
MAGIC_KEYBOARD_ID="80-95-3a-b7-13-7a"
MAGIC_TRACKPAD_ID="34-b1-eb-ec-30-6f"

# Call the function with the Magic Keyboard and Trackpad IDs
pair_or_unpair_device $MAGIC_KEYBOARD_ID
pair_or_unpair_device $MAGIC_TRACKPAD_ID
