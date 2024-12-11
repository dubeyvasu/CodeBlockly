// Initialize Blockly in the workspace
var workspace = Blockly.inject('blocklyDiv', {
    toolbox: `<xml xmlns="http://www.w3.org/1999/xhtml">
                <category name="Basic" colour="#D6A65C">
                    <block type="arduino_setup"></block>
                    <block type="arduino_loop"></block>
                    <block type="delay"></block>
                </category>
                <!-- Logic Blocks -->
                <category name="Logic" colour="#5C81A6" >

                    <block type="controls_if"></block>
                    <block type="controls_ifelse"></block>
                    <block type="logic_compare"></block>
                    <block type="logic_operation"></block>
                    <block type="logic_boolean"></block>
                    <block type="logic_ternary"></block>
                </category>

                <!-- Loops Blocks -->
                <category name="Loops" colour="#5CA65C">
                    <block type="controls_repeat_ext"></block>
                    <block type="controls_whileUntil"></block>
                    <block type="controls_for"></block>
                    <block type="controls_forEach"></block>
                    <block type="controls_flow_statements"></block>
                </category>

                <!-- Math Blocks -->
                <category name="Math" colour="#5C68A6">
                    <block type="math_number"></block>
                    <block type="math_arithmetic"></block>
                    <block type="math_single"></block>
                    <block type="math_trig"></block>
                    <block type="math_constant"></block>
                    <block type="math_number_property"></block>
                </category>

                <!-- Text Blocks -->
                <category name="Text" colour="#5CA68D">
                    <block type="text"></block>
                    <block type="text_print"></block>
                </category>

                <!-- Variables Blocks -->
                <category name="Variables" custom="VARIABLE" colour="#A65C81"></category>

                <!-- Functions Blocks -->
                <category name="Functions" custom="PROCEDURE" colour="#9A5CA6"></category>

                <!-- Custom Blocks -->
                <category name="Custom" colour="#D6A65C">
                    <block type="turn_led_on"></block>
                    <block type="turn_led_off"></block>
                    <block type="pin_mode"></block>
                    <block type="digital_write"></block>
                    <block type="analog_read"></block>
                    <block type="digital_read"></block>
                    <block type="read_temperature"></block>
                    <block type="led_control"></block>
                    <block type="motor_control"></block>
                    <block type="buzzer_control"></block>
                    <block type="serial_begin"></block>
                    <block type="serial_print"></block>
                    <block type="serial_println"></block>
                    <block type="serial_read"></block>
                    <block type="serial_control"></block>
                    <block type="bluetooth_begin"></block>
                    <block type="bluetooth_send"></block>
                    <block type="bluetooth_receive"></block>
                    <block type="sd_init"></block>
                    <block type="sd_write"></block>
                    <block type="lcd_print"></block>
                    <block type="serial_plotter"></block>
                    <block type="wifi_connect"></block>
                    <block type="wifi_status"></block>
                    <block type="http_get"></block>
                    <block type="bluetooth_init"></block>
                    <block type="bluetooth_send"></block>
                    <block type="read_dht"></block>
                    <block type="ultrasonic_read"></block>
                    <block type="display_oled"></block>
                </category>
                <category name="Advanced Control" colour="#FFAB19">
                    <block type="pwm_control"></block>
                    <block type="servo_control"></block>
                </category>
              </xml>`,
              zoom: {
                controls: true,  // Show zoom controls (buttons)
                wheel: true,     // Enable zooming with the mouse wheel
                startScale: 1,   // Initial zoom level (1 = 100%)
                maxScale: 3,     // Maximum zoom level (3 = 300%)
                minScale: 0.3    // Minimum zoom level (0.3 = 30%)
            },
            grid: {
                spacing: 20,       // Spacing between dots (distance in pixels)
                length: 3,         // Length of the dots (set it low to look like dots)
                colour: '#ccc',    // Color of the dots
                snap: true         // Whether blocks should snap to the grid
              }
});

// Generate JavaScript code from the blocks
document.getElementById('generateCode').addEventListener('click', function() {
    var code = Blockly.Python.workspaceToCode(workspace);
    console.log(Blockly.Xml.domToText(Blockly.Xml.workspaceToDom(workspace))); 
    var codeArea = document.getElementById('codeArea');
    
    if (code) {
        codeArea.textContent = code;  // Show the generated code in the <pre> element
    } else {
        codeArea.textContent = "No blocks in workspace! Add blocks to generate code.";
    }
});


// Save the Workspace to local storage
document.getElementById('saveWorkspace').addEventListener('click', function() {
    var xml = Blockly.Xml.workspaceToDom(workspace);  // Convert workspace to XML
    var xml_text = Blockly.Xml.domToPrettyText(xml);  // Make it pretty-printed
    localStorage.setItem('savedBlocks', xml_text);    // Save it in local storage
    alert("Workspace saved successfully!");
});

// Load the Workspace from local storage
document.getElementById('loadWorkspace').addEventListener('click', function() {
    var xml_text = localStorage.getItem('savedBlocks');
    if (xml_text) {
        var xml = Blockly.Xml.textToDom(xml_text);   // Convert text back to XML
        workspace.clear();                           // Clear current workspace
        Blockly.Xml.domToWorkspace(xml, workspace);  // Load the saved blocks
        alert("Workspace loaded successfully!");
    } else {
        alert("No saved workspace found.");
    }
});

// Download the generated code as a file
document.getElementById('downloadCode').addEventListener('click', function() {
    var code = Blockly.JavaScript.workspaceToCode(workspace);  // Generate code
    if (code) {
        var blob = new Blob([code], { type: 'text/plain' });    // Create a file blob
        var link = document.createElement('a');
        link.href = URL.createObjectURL(blob);
        link.download = 'code.ino';   // Download as Arduino .ino file
        link.click();                 // Trigger the download
    } else {
        alert("No code to download! Please add blocks to the workspace.");
    }
});

document.getElementById('uploadButton').onclick = async () => {
    await uploadCodeToMicrocontroller();
};


document.addEventListener('DOMContentLoaded', () => {
    // document.getElementById('connect-usb').onclick = async () => {
    //     await connectWithWebUSB();
    // };

    document.getElementById('connect-serial').onclick = async () => {
        await connectMicrocontroller();
    };

    if (!('usb' in navigator)) {
        console.error('WebUSB is not supported by this browser.');
    }
});


// async function connectWithWebUSB() {
// try {
//     const device = await navigator.usb.requestDevice({
//         filters: [{ vendorId: 0x1A86, productId: 0x7523 }]
//     });
//     await device.open();
//     await device.selectConfiguration(1);
//     await device.claimInterface(0);

//     const data = new TextEncoder().encode('Hello from WebUSB!');
//     await device.transferOut(1, data);

//     updateOutput('Sent data via WebUSB\n');
// } catch (error) {
//     console.error('WebUSB Error:', error);
//     updateOutput('WebUSB Error: ' + error.message + '\n');
// }
// }

async function connectMicrocontroller() {
    try {
        const port = await navigator.serial.requestPort({
            filters: [{ usbVendorId: 0x1A86, usbProductId: 0x7523 }] // Updated property names
        });
        await port.open({ baudRate: 115200 });

        const writer = port.writable.getWriter();
        const encoder = new TextEncoder();
        const data = encoder.encode('Hello from Web Serial!');
        await writer.write(data);
        writer.releaseLock();

        updateOutput('Sent data via Web Serial\n');
    } catch (error) {
        console.error('Web Serial Error:', error);
        updateOutput('Web Serial Error: ' + error.message + '\n');
    }
}

function updateOutput(message) {
    const outputElement = document.getElementById('output');
    if (outputElement) {
        outputElement.textContent += message;
    } else {
        console.error('Output element not found.');
    }
}

async function uploadCodeToMicrocontroller() {
    try {
        // Request access to a port
        const port = await navigator.serial.requestPort();
        
        // Open the port at 9600 baud rate
        await port.open({ baudRate: 9600 });

        // Write code to the microcontroller
        const writer = port.writable.getWriter();
        const code = Blockly.Arduino.workspaceToCode(workspace); // Get generated code
        await writer.write(new TextEncoder().encode(code));

        writer.releaseLock();
        await port.close();

        document.getElementById('output').innerText = 'Code uploaded successfully!';
    } catch (error) {
        document.getElementById('output').innerText = `Error: ${error.message}`;
        console.error('Error during upload:', error);
    }
}


