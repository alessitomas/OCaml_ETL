from fastapi import FastAPI
from fastapi.responses import JSONResponse
import pandas as pd

app = FastAPI()


order_data = pd.read_csv("data/order.csv")
orderm_item = pd.read_csv("data/order_item.csv")

@app.get("/order")
def get_data1():
    return JSONResponse(content=order_data.to_dict(orient="records"))

@app.get("/orderItem")
def get_data2():
    return JSONResponse(content=orderm_item.to_dict(orient="records"))

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
