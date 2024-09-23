<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="System.Security.Cryptography" %>
<!DOCTYPE html>
<html>
<head>
    <title>Encrypt File</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Button ID="EncryptButton" runat="server" Text="Encrypt File" OnClick="EncryptButton_Click" />
        </div>
    </form>

    <script runat="server">
        protected void EncryptButton_Click(object sender, EventArgs e)
        {
            try
            {
                // File paths
                string currentDirectory = AppDomain.CurrentDomain.BaseDirectory;
                string inputFile = System.IO.Path.Combine(currentDirectory, "Hello.txt");
                string encryptedFile = System.IO.Path.Combine(currentDirectory, "Encrypted_Hello.txt");

                // RSA public key XML
                string publicKeyXML = @"
                    <RSAKeyValue>
                        <Modulus>3ZW3PEPdy30SekAkoiJ2HwQmJZl9Mzn2L0YBO7JYSMfA3nKwHMxpr/xTkLRQUSfXpCU7iJT8ffgnlFT6a5wxH/aGYTn2o9EZtiTU/PKEvpmhCt4dEu18Seh6GLtVQEoVKn8hSFuBYaM3P8wFjbbuVeEc7T3cqpsZG+Li0dSoupgvLE+kgV1GO3J6lwRS5PK7k4F5pphvhzLSy9XxKEJeYvoq1T3vo2TQ/L+Nf8ZKO+8kezpYfHg0K5NsYWS88UxOVcHPJrAF4SSMTYzARU8h9Nxq6n73g1Qrveja0adRELTCbXCP/VSdi+UZS3Ekg4HvQ7voO82bJ33Oa++N47xv/Q==</Modulus>
                        <Exponent>AQAB</Exponent>
                    </RSAKeyValue>";

                // Read the content to encrypt
                string dataToEncrypt = System.IO.File.ReadAllText(inputFile);

                // Encrypt the content
                byte[] encryptedContent = EncryptData(dataToEncrypt, publicKeyXML);

                // Convert encrypted content to Base64 string
                string base64EncryptedContent = Convert.ToBase64String(encryptedContent);

                // Write encrypted content to file
                System.IO.File.WriteAllText(encryptedFile, base64EncryptedContent);

                Response.Write("Encryption successful.");
            }
            catch (Exception ex)
            {
                Response.Write("Error: " + ex.Message);
            }
        }

        private static byte[] EncryptData(string data, string publicKeyXML)
        {
            using (var rsa = new RSACryptoServiceProvider())
            {
                rsa.FromXmlString(publicKeyXML);
                byte[] dataToEncrypt = Encoding.UTF8.GetBytes(data);
                return rsa.Encrypt(dataToEncrypt, false); // false indicates PKCS#1 v1.5 padding
            }
        }
    </script>
</body>
</html>
