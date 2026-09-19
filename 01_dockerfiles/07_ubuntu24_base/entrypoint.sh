#!/bin/bash

# Set XDG_RUNTIME_DIR if not already set
if [ -z "$XDG_RUNTIME_DIR" ]; then
    export XDG_RUNTIME_DIR=/run/user/$(id -u)
fi

# If DBUS_SESSION_BUS_ADDRESS is not set from host, try to launch dbus
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    echo "=== DBUS_SESSION_BUS_ADDRESS not set, launching dbus-launch ==="
    if command -v dbus-launch >/dev/null 2>&1; then
        eval "$(dbus-launch --sh-syntax)"
        echo "DBus launched: $DBUS_SESSION_BUS_ADDRESS"
    else
        echo "dbus-launch not found, creating local DBus"
    fi
fi

# If DBUS_SESSION_BUS_ADDRESS is passed from host or created above, use it directly
# Otherwise, create a local one
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    echo "=== Creating Local DBus ==="
    
    # Kill any existing ibus/dbus processes
    killall -9 ibus-daemon 2>/dev/null || true
    killall -9 dbus-daemon 2>/dev/null || true
    sleep 1

    # Ensure runtime directory exists
    if [ ! -d "$XDG_RUNTIME_DIR" ]; then
        mkdir -p "$XDG_RUNTIME_DIR"
        chmod 700 "$XDG_RUNTIME_DIR"
    fi

    # Clean up old socket files
    rm -f "$XDG_RUNTIME_DIR/dbus/session-bus-socket" 2>/dev/null || true
    mkdir -p "$XDG_RUNTIME_DIR/dbus"
    chmod 700 "$XDG_RUNTIME_DIR/dbus"

    # Start DBus daemon
    export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/dbus/session-bus-socket"
    echo "Starting local DBus at: $DBUS_SESSION_BUS_ADDRESS"
    dbus-daemon --session --address="$DBUS_SESSION_BUS_ADDRESS" --print-address --fork 2>&1 | head -1

    # Wait for DBus socket to be created
    for i in {1..10}; do
        if [ -S "$XDG_RUNTIME_DIR/dbus/session-bus-socket" ]; then
            echo "DBus socket created successfully"
            break
        fi
        sleep 0.5
    done

    sleep 1

else
    echo "=== Using Host/Launched DBus ==="
    echo "DBUS_SESSION_BUS_ADDRESS: $DBUS_SESSION_BUS_ADDRESS"
    
    # Verify the bus socket exists
    BUS_SOCKET=$(echo "$DBUS_SESSION_BUS_ADDRESS" | sed 's|unix:path=||')
    echo "Bus socket path: $BUS_SOCKET"
    
    if [ -S "$BUS_SOCKET" ]; then
        echo "Bus socket found and is a socket"
        ls -la "$BUS_SOCKET"
    else
        echo "Warning: Bus socket not found or not a socket"
        ls -la "$(dirname "$BUS_SOCKET")" 2>&1 || true
    fi
    
    # Kill any existing ibus processes (but not dbus)
    killall -9 ibus-daemon 2>/dev/null || true
    sleep 1
    
    # Test DBus connection
    echo "Testing DBus connection..."
    if dbus-send --session --print-reply --dest=org.freedesktop.DBus /org/freedesktop/DBus org.freedesktop.DBus.ListNames >/dev/null 2>&1; then
        echo "DBus connection OK"
    else
        echo "Warning: DBus connection test failed"
    fi
fi

# Setup ibus environment variables
export XMODIFIERS=@im=ibus
export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export CLUTTER_IM_MODULE=ibus

# Initialize ibus components
echo "=== Initializing ibus components ==="
mkdir -p ~/.cache/ibus ~/.config/ibus
ibus read-cache 2>&1 || true
sleep 1

# Start ibus daemon with XIM support
echo "=== Starting ibus daemon with XIM ==="

# Try to start ibus-daemon directly with XIM
ibus-daemon -d --xim --verbose 2>&1 &
IBUS_PID=$!
echo "ibus-daemon PID: $IBUS_PID"

# Wait for ibus to fully initialize
sleep 4

# Rebuild ibus cache and registry
echo "=== Rebuilding ibus cache and registry ==="
ibus write-cache 2>&1 || true
sleep 2

# Check if ibus daemon is running and connected
echo "=== Verifying ibus connection ==="
if ibus address >/dev/null 2>&1; then
    echo "ibus connected to DBus: $(ibus address)"
    
    # List available engines
    echo "=== Checking available ibus engines ==="
    ibus list-engine 2>&1 || echo "Warning: Could not list engines"
    
    # Set hangul engine
    echo "Setting hangul engine..."
    sleep 1
    ibus engine hangul 2>&1 || echo "Warning: Could not set hangul engine"
    
    # Verify hangul is set
    CURRENT_ENGINE=$(ibus engine 2>&1)
    echo "Current engine: $CURRENT_ENGINE"
    
    # Initialize XIM server
    echo "Starting XIM server..."
    ibus restart 2>&1 || true
    sleep 2
    
    # Explicitly set XIM keyboard
    export XMODIFIERS="@im=ibus"
    
    echo "ibus setup complete"
else
    echo "Warning: ibus address returned null"
    echo "Attempting ibus restart..."
    sleep 2
    ibus restart 2>&1 || true
    sleep 3
    ibus write-cache 2>&1 || true
    sleep 1
    ibus engine hangul 2>&1 || true
fi

echo "=== Entrypoint initialization complete ==="

# Execute the command passed to the container
exec "$@"
