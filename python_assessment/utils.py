import json
from typing import List, Union, TypedDict, NotRequired, Callable

from datetime import datetime


class Contract(TypedDict):
    contract_id: Union[int, str]
    bank: NotRequired[str]
    summa: Union[int, str]
    loan_summa: Union[int, str]
    claim_date: str
    claim_id: Union[int, str]
    contract_date: str


def no_claims(func: Callable) -> Callable:
    def inner(*args, **kwargs):
        if args[0] is None:
            return -3
        json_data = json.loads(args[0])
        if type(json_data) == dict:
            json_data = [json_data]
        json_contract: List[Contract] = json_data
        return func(json_contract, *args[1:], **kwargs)

    return inner


@no_claims
def tot_claim_cnt_l180d(claims: List[Contract]) -> int:
    cnt = 0
    today = datetime.now()
    for claim in claims:
        if (today - datetime.strptime(claim['claim_date'], '%d.%m.%Y')).days < 180:
            cnt += 1
    return cnt


@no_claims
def disb_bank_loan_wo_tbc(claims: List[Contract]) -> int:

    filtered_claims = list(
        filter(lambda x: x.get('bank', None) not in ['LIZ', 'LOM', 'MKO', 'SUG', None] and x['contract_date'] != '',
               claims)
    )
    if len(filtered_claims) == 0:
        return -1

    loan_sum = 0
    for claim in filtered_claims:
        if (type(claim['loan_summa']) == int or type(claim['loan_summa']) == str and claim['loan_summa'].isdigit()) and \
                claim['contract_date'] != '':
            loan_sum += int(claim['loan_summa'])

    return loan_sum


@no_claims
def day_sinlastloan(claims: List[Contract], application_date: str) -> int:

    filtered_claims = filter(lambda x: x['summa'] != '', claims)

    sorted_claims = sorted(filtered_claims, key=lambda x: datetime.strptime(x['claim_date'], '%d.%m.%Y'))
    if len(sorted_claims) == 0:
        return -1

    application_date = datetime.strptime(application_date.split()[0], '%Y-%m-%d')

    return (application_date - datetime.strptime(sorted_claims[-1]['claim_date'], '%d.%m.%Y')).days
