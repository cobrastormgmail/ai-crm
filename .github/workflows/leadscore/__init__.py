import logging
import azure.functions as func

def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info("Leadscore function triggered.")
    return func.HttpResponse("Leadscore API working!", status_code=200)
