String getWelcomeEmailTemplate({required String name, required String email, required String password}) {
  return """
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Welcome to Health & Wellness</title>
</head>
<body style="margin:0; padding:0; background-color:#f4f6f8; font-family: Arial, sans-serif;">
  <table width="100%" cellpadding="0" cellspacing="0" style="background-color:#f4f6f8; padding:20px;">
    <tr>
      <td align="center">
        <table width="600" cellpadding="0" cellspacing="0" style="background:#ffffff; border-radius:10px; overflow:hidden;">
          
          <!-- Header -->
          <tr>
            <td style="background:#2e7d32; color:#ffffff; padding:20px; text-align:center;">
              <h1 style="margin:0;">Health & Wellness</h1>
            </td>
          </tr>

          <!-- Body -->
          <tr>
            <td style="padding:30px;">
              <h2 style="margin-top:0;">Welcome, $name</h2>
              <p style="color:#555; font-size:16px;">
                We're excited to have you on board! Your account has been successfully created.
              </p>

              <p style="font-size:16px; color:#333;">
                <strong>Login Details:</strong>
              </p>

              <table cellpadding="8" cellspacing="0" style="width:100%; background:#f9f9f9; border-radius:8px;">
                <tr>
                  <td><strong>Email:</strong></td>
                  <td>$email</td>
                </tr>
                <tr>
                  <td><strong>Password:</strong></td>
                  <td>$password</td>
                </tr>
              </table>

              <p style="margin-top:20px; font-size:15px; color:#555;">
                You can log in using your email and password.
              </p>

              <!-- Button -->
              <div style="text-align:center; margin-top:30px;">
                <a href="#" style="
                  background:#2e7d32;
                  color:#ffffff;
                  padding:12px 25px;
                  text-decoration:none;
                  border-radius:5px;
                  font-size:16px;
                  display:inline-block;">
                  Login Now
                </a>
              </div>

              <p style="margin-top:30px; font-size:14px; color:#888;">
                If you did not request this account, please ignore this email.
              </p>
            </td>
          </tr>

          <!-- Footer -->
          <tr>
            <td style="background:#f1f1f1; text-align:center; padding:15px; font-size:12px; color:#777;">
              © ${DateTime.now().year} Health & Wellness. All rights reserved.
            </td>
          </tr>

        </table>
      </td>
    </tr>
  </table>
</body>
</html>
""";
}
