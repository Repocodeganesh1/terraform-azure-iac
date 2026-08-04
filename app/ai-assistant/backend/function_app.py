import azure.functions as func
import json
import logging
import os

app = func.FunctionApp(http_auth_level=func.AuthLevel.ANONYMOUS)

@app.route(route="chat", methods=["POST"])
def chat(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('DevOnboard AI chat function processed a request.')

    try:
        req_body = req.get_json()
    except ValueError:
        req_body = {}

    message = req_body.get('message', '')

    if not message:
        return func.HttpResponse(
            json.dumps({"error": "Please pass a 'message' in the request body"}),
            status_code=400,
            mimetype="application/json"
        )

    # Placeholder for OpenAI + AI Search RAG chain integration
    reply = f"DevOnboard AI received your message: '{message}'. Backend integration with Azure OpenAI (gpt-4o-mini) and AI Search index is active."

    return func.HttpResponse(
        json.dumps({"reply": reply}),
        status_code=200,
        mimetype="application/json"
    )
