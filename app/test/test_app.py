from src.app import create_app

def test_health():
    client = create_app().test_client()
    resp = client.get("/health")
    assert resp.status_code == 200
    assert resp.get_json()["status"] == "ok"

def test_quote():
    client = create_app().test_client()
    resp = client.get("/quote")
    data = resp.get_json()
    assert resp.status_code == 200
    assert "quote" in data
    assert isinstance(data["quote"], str) and data["quote"]
