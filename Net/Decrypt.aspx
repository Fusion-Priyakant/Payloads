<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="System.Security.Cryptography" %>
<!DOCTYPE html>
<html>
<head>
    <title>Decrypt File</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Button ID="DecryptButton" runat="server" Text="Decrypt File" OnClick="DecryptButton_Click" />
        </div>
    </form>

    <script runat="server">
        protected void DecryptButton_Click(object sender, EventArgs e)
        {
            try
            {
                // File paths
                string currentDirectory = AppDomain.CurrentDomain.BaseDirectory;
                string encryptedFile = System.IO.Path.Combine(currentDirectory, "Encrypted_Hello.txt");
                string decryptedFile = System.IO.Path.Combine(currentDirectory, "Decrypted_Hello.txt");

                // RSA private key XML
                string privateKeyXML = @"
                    <RSAKeyValue>
                        <Modulus>3ZW3PEPdy30SekAkoiJ2HwQmJZl9Mzn2L0YBO7JYSMfA3nKwHMxpr/xTkLRQUSfXpCU7iJT8ffgnlFT6a5wxH/aGYTn2o9EZtiTU/PKEvpmhCt4dEu18Seh6GLtVQEoVKn8hSFuBYaM3P8wFjbbuVeEc7T3cqpsZG+Li0dSoupgvLE+kgV1GO3J6lwRS5PK7k4F5pphvhzLSy9XxKEJeYvoq1T3vo2TQ/L+Nf8ZKO+8kezpYfHg0K5NsYWS88UxOVcHPJrAF4SSMTYzARU8h9Nxq6n73g1Qrveja0adRELTCbXCP/VSdi+UZS3Ekg4HvQ7voO82bJ33Oa++N47xv/Q==</Modulus>
                        <Exponent>AQAB</Exponent>
                        <P>47zX4TrkEpGKOVqfQa2B9kSm5B+c5tgORwejICNpoz/QSsWxnalgHELt56CVtAJkheP6lbZQhhNkKIfOJ3jQmLf2Be3CORK0R7KAOjmqecmCVM3ozd0ggy8oleRbPixd/rZxry8dMq/a2aS+cGq4XOXucgitvukw+JNxzZHT96M=</P>
                        <Q>+RVmCCQwbqrXtKa/2W4zHa1AqR+gRb5oIlnmd2oPta2fXyWELhIe2q7b9yXMiGbFlEJIXsaZI8Msg/ogIo9zZ12xZSgnvmzxUeVlD8X4AqwFTu/3c4OcY/n7mCiLVJ5AFsfzTg+FrwceggBGwVxbMD4LXwfie+X/Leycy9hY898=</Q>
                        <DP>mKMYef/znzJm11wSw31cTsfip6E8k0gaAadvwPmbMuxxWbw4+HfuT+LX+1gZHkZAQ7DyYeeI/uP+TGABX1lNTh52SbD6bTBJHojYAq5lwSy7KsW7lEbyJJq19AjS0s//y9lSRt0oD7Hn19ngPg55NOJzN4DzmrJGvURtkR99V0s=</DP>
                        <DQ>YjCgTzdM7GNmsy1E1cbOWbWRltoDyVqdHGWKJ6rk1H7EI7LbX3n/Nb/WsJ/y+BZjbuWON+ZcOi/XXZN9lYItQSM7KiBhQn0ZyGoAo+4rrYn4cbzBNIU+Yl8KYlohStMzeoeKD0ypK21IBoFrYxAwVl0vCGBIVQU+yfDLgsQflMs=</DQ>
                        <InverseQ>p0oJApOOCaViFY4Bet2CTddBsYYsAiNkYvsM/TIOd4eglWYwE6FuykuDBpRYRQjk5j66Y2dL8mrZgPRNlLQU4YKk8vgCtL6cYReAu5WgkXrUTGxJ1JMt/8CBaO3hWm/cDbt2UUgIxqOL2S9D6yID4hKhEDExXakkk3dz4w4RCKk=</InverseQ>
                        <D>espFYRsGpIXpoF89La/FH0jwTrOwwptjBi1X75nT/HjdMygA2eSYyJIeSLjzLRXUFL0hMX3GMZQ7cqJopwtF2b2GGAjD2WG9Ssc8U/OchfaiXGBbYirCTj6KsnvVMSwccJFEg1FZ8B4/NpY7mZ1+k46Mthcq2kvabS6cnMSov8UfW5QpzEThDatBDIgi0tzcsNuYOmpDPR5bmDE5EmJFKS6YY5ghNZeU7a/ZpBiC5IKWSCFTg8GcfKFqbE26PdKBclptizIFtBdiLjHfg5q5l0cGnH5S1fZXZc1bJCjfB/321Pzn086wFLySOs/lEnBk5c5rgmWfpy9ZV4gwUdCrDQ==</D>
                    </RSAKeyValue>";

                // Read the encrypted content from file
                string base64EncryptedContent = System.IO.File.ReadAllText(encryptedFile);
                
                // Convert Base64 string to byte array
                byte[] encryptedContent = Convert.FromBase64String(base64EncryptedContent);

                // Decrypt the content
                byte[] decryptedContent = DecryptData(encryptedContent, privateKeyXML);

                // Convert decrypted content to string
                string decryptedText = Encoding.UTF8.GetString(decryptedContent);

                // Write decrypted content to file
                System.IO.File.WriteAllText(decryptedFile, decryptedText);

                Response.Write("Decryption successful.");
            }
            catch (Exception ex)
            {
                Response.Write("Error: " + ex.Message);
            }
        }

        private static byte[] DecryptData(byte[] data, string privateKeyXML)
        {
            using (var rsa = new RSACryptoServiceProvider())
            {
                rsa.FromXmlString(privateKeyXML);
                return rsa.Decrypt(data, false); // false indicates PKCS#1 v1.5 padding
            }
        }
    </script>
</body>
</html>
