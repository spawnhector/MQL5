#import

class CWebSocket
{
private:
   string m_url;            // URL of the WebSocket server
   int m_timeout;          // connection timeout
   int m_redirects;        // number of redirects
   bool m_verify;          // verify the certificate
   bool m_binary;          // request data type

public:
   // constructor
   CWebSocket(string url, int timeout=30000, int redirects=10, bool verify=true, bool binary=false)
   {
      m_url = url;
      m_timeout = timeout;
      m_redirects = redirects;
      m_verify = verify;
      m_binary = binary;
   }

   // send a request to the WebSocket server
   bool SendRequest(string method, string headers="", string data="")
   {
      int result = WebRequest(method, m_url, headers, data, m_timeout, m_redirects, m_verify, m_binary);
      if (result == 200)
         return(true);
      else
         return(false);
   }
};

#import