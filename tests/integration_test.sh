#!/usr/bin/env bash
# Copyright 2019 AstroLab Software
# Author: Abhishek Chauhan
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This is a simple integration test
set -e

# start Kafka in docker container
docker-compose -p integration_test -f docker-compose-kafka.yml up -d

# simulate stream of alerts on test topics
coverage run --rcfile ../.coveragerc --source=${PWD} testProducer.py

# consume simulated stream of alerts
coverage run --rcfile ../.coveragerc --source=${PWD} testConsumer.py

coverage combine
coverage report
coverage html

# shut down kafka container
docker-compose -p integration_test -f docker-compose-kafka.yml down
