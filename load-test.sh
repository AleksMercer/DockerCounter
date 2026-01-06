import requests
import time
import sys

def test_performance(url, requests_count=100):
    """Минимальный нагрузочный тест"""
    print(f"Testing {url} with {requests_count} requests...")
    
    # GET тест
    start = time.time()
    for i in range(requests_count):
        response = requests.get(f"{url}/api/counter")
        if response.status_code != 200:
            print(f"Error: {response.status_code}")
    get_time = time.time() - start
    
    # POST тест (10 запросов)
    start = time.time()
    for i in range(10):
        response = requests.post(f"{url}/api/counter/increment")
        if response.status_code != 200:
            print(f"Error: {response.status_code}")
    post_time = time.time() - start
    
    return {
        "get_requests_per_second": requests_count / get_time,
        "post_requests_per_second": 10 / post_time,
        "total_time": get_time + post_time
    }

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python load-test.py <base_url>")
        sys.exit(1)
    
    url = sys.argv[1].rstrip('/')
    results = test_performance(url, 100)
    
    print("\n=== Results ===")
    print(f"GET RPS: {results['get_requests_per_second']:.2f}")
    print(f"POST RPS: {results['post_requests_per_second']:.2f}")
    print(f"Total time: {results['total_time']:.2f}s")