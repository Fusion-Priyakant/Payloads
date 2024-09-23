<%@ WebService Language="C#" Class="EncryptService" %>

using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using System.Web.Services;

public class EncryptService : WebService
{
    [WebMethod]
    public string EncryptFile()
    {
        try
        {
            // Paths to the input and output files
            string currentDirectory = AppDomain.CurrentDomain.BaseDirectory;
            string inputFile = Path.Combine(currentDirectory, "Hello.txt");
            string encryptedFile = Path.Combine(currentDirectory, "Encrypted_Hello.txt");

            // The RSA public key in XML format
            string publicKeyXML = @"
                <RSAKeyValue>
                    <Modulus>3ZW3PEPdy30SekAkoiJ2HwQmJZl9Mzn2L0YBO7JYSMfA3nKwHMxpr/xTkLRQUSfXpCU7iJT8ffgnlFT6a5wxH/aGYTn2o9EZtiTU/PKEvpmhCt4dEu18Seh6GLtVQEoVKn8hSFuBYaM3P8wFjbbuVeEc7T3cqpsZG+Li0dSoupgvLE+kgV1GO3J6lwRS5PK7k4F5pphvhzLSy9XxKEJeYvoq1T3vo2TQ/L+Nf8ZKO+8kezpYfHg0K5NsYWS88UxOVcHPJrAF4SSMTYzARU8h9Nxq6n73g1Qrveja0adRELTCbXCP/VSdi+UZS3Ekg4HvQ7voO82bJ33Oa++N47xv/Q==</Modulus>
                    <Exponent>AQAB</Exponent>
                </RSAKeyValue>";

            // Read the file content
            string fileContent = File.ReadAllText(inputFile);

            // Encrypt the file content using the public key
            byte[] encryptedContent = EncryptData(fileContent, publicKeyXML);

            // Convert encrypted content to Base64
            string encryptedBase64 = Convert.ToBase64String(encryptedContent);

            // Write the Base64 encrypted content to the output file
            File.WriteAllText(encryptedFile, encryptedBase64);

            return "File encrypted successfully.\r\n" + encryptedBase64;
        }
        catch (Exception ex)
        {
            return "Error: " + ex.Message;
        }
    }

    private static byte[] EncryptData(string data, string publicKeyXML)
    {
        byte[] dataToEncrypt = Encoding.UTF8.GetBytes(data);

        using (var rsa = new RSACryptoServiceProvider())
        {
            rsa.FromXmlString(publicKeyXML);
            // Using PKCS1 padding, which is supported by RSACryptoServiceProvider
            return rsa.Encrypt(dataToEncrypt, false); // PKCS1 padding by default
        }
    }
}
