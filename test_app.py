# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import unittest
import json
from app import app
import os

class TestApp(unittest.TestCase):

  def test_predict(self):
    a = app.test_client()
    testkeys = set(os.environ.get('_TEST_KEYS').split(','))
    url = '/predict'
    message = {"response":"Test message"}
    req = a.post(url,json=message,content_type='application/json')
    out = req.get_json()
    self.assertEqual(set(out.keys()), testkeys)

if __name__ == '__main__':
  unittest.main()