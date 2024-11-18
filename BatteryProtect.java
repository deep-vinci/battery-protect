import java.io.*;
import java.nio.file.*;
import java.time.LocalDateTime;

public class BatteryProtect {
    public static void main(String[] args) {
        final int upperThresholdPercentage = 80;
        final String controlFilePath = System.getProperty("user.home") + "/battery-enable";

        // Check if notifications are enabled
        if (!Files.exists(Paths.get(controlFilePath))) {
            return;
        }

        try {
            // Retrieve battery percentage and status
            String batteryInfoCommand = "upower -i $(upower -e | grep 'BAT')";
            Process process = new ProcessBuilder("bash", "-c", batteryInfoCommand).start();

            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            String line;
            int batteryPercentage = 0;
            String batteryStatus = "";
            
            while ((line = reader.readLine()) != null) {
                if (line.trim().startsWith("percentage:")) {
                    batteryPercentage = Integer.parseInt(line.split(":")[1].trim().replace("%", ""));
                }
                if (line.trim().startsWith("state:")) {
                    batteryStatus = line.split(":")[1].trim();
                }
            }
            process.waitFor();

            // Check the conditions and notify
            if ("charging".equalsIgnoreCase(batteryStatus) && batteryPercentage >= upperThresholdPercentage) {
                // Log to file
                String logMessage = LocalDateTime.now() + " - Battery is charged to " + batteryPercentage + "%\n";
                Files.write(Paths.get("log.txt"), logMessage.getBytes(), StandardOpenOption.CREATE, StandardOpenOption.APPEND);

                // Send notification
                String notificationCommand = String.format(
                    "/usr/bin/notify-send \"Remove Charger\" \"Battery %d%% Charged.\" --icon=\"%s/Documents/stupid-scripts/battery-protect/danger-logo.png\" --urgency=\"critical\" --app-name=\"Battery Protect\"",
                    batteryPercentage, System.getProperty("user.home")
                );
                new ProcessBuilder("bash", "-c", notificationCommand).start();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

