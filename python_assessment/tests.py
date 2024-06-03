import unittest

from utils import tot_claim_cnt_l180d, disb_bank_loan_wo_tbc, day_sinlastloan
from datetime import datetime


class TestTotClaimCntL180d(unittest.TestCase):
    def test_tot_claim_cnt_l180d(self):
        self.assertEqual(tot_claim_cnt_l180d(None), -3)

    def test_tot_claim_cnt_l180d_0(self):
        value = """{'contract_id': 522530,
                  'bank': '003',
                  'summa': 500000000,
                  'loan_summa': 0,
                  'claim_date': '13.02.2020',
                  'claim_id': 609965,
                  'contract_date': '17.02.2020'
                 }"""
        self.assertEqual(tot_claim_cnt_l180d(value), 0)

    def test_tot_claim_cnt_l180d_1(self):
        value = f"""[{{'contract_id': 522530,
                 'bank': '003',
                 'summa': 500000000,
                 'loan_summa': 0,
                 'claim_date': '13.02.2020',
                 'claim_id': 609965,
                 'contract_date': '17.02.2020'
                 }},
                 {{'contract_id': '',
                  'bank': '063',
                  'summa': '',
                  'loan_summa': '',
                  'claim_date': '{datetime.now().strftime('%d.%m.%Y')}',
                  'claim_id': 554498885,
                  'contract_date': ''}}
         ]"""
        print(value)
        self.assertEqual(tot_claim_cnt_l180d(value), 1)