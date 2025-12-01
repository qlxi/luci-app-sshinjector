#!/usr/bin/python3
import socket
import sys
import argparse
import select

def parse_payload(payload_raw, dest_host, dest_port):
    p = payload_raw
    p = p.replace('[crlf]', '\r\n')
    p = p.replace('[CRLF]', '\r\n')
    p = p.replace('[lf]', '\n')
    p = p.replace('[host]', dest_host)
    p = p.replace('[port]', str(dest_port))
    p = p.replace('[host_port]', f"{dest_host}:{dest_port}")
    p = p.replace('[protocol]', 'HTTP/1.1')
    p = p.replace('[split]', '') 
    return p.encode('utf-8')

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--host", required=True)
    parser.add_argument("--port", required=True, type=int)
    parser.add_argument("--payload", required=True)
    parser.add_argument("--proxy_ip", default=None)
    parser.add_argument("--proxy_port", default=None, type=int)
    
    args = parser.parse_args()

    connect_host = args.proxy_ip if args.proxy_ip else args.host
    connect_port = args.proxy_port if args.proxy_port else args.port

    try:
        s = socket.create_connection((connect_host, connect_port), timeout=10)
        
        final_payload = parse_payload(args.payload, args.host, args.port)
        s.sendall(final_payload)

        s.setblocking(0)
        
        while True:
            r, _, _ = select.select([sys.stdin, s], [], [])
            
            if s in r:
                data = s.recv(4096)
                if not data: break
                sys.stdout.buffer.write(data)
                sys.stdout.buffer.flush()
                
            if sys.stdin in r:
                data = sys.stdin.buffer.read(4096)
                if not data: break
                s.sendall(data)

    except Exception as e:
        sys.stderr.write(f"Connection failed: {e}\n")
        sys.exit(1)
    finally:
        try: s.close()
        except: pass

if __name__ == "__main__":
    main()
