

#!/usr/bin/env python
#-*- coding: iso-8859-15 -*-


# use packages
import sys
import os
import math
import re
import Queue
import time
import optparse
import random
import commands
import logging
from threading import ThreadError
from threading import Thread
sys.path.append('/cs/taatto/group/urenzyme/workspace/netscripts/')
from get_free_nodes import get_free_nodes


job_queue = Queue.Queue()

# worker class
# job is a tuple of parameters
class Worker(Thread):
  def __init__(self, job_queue, node):
    Thread.__init__(self)
    self.job_queue  = job_queue
    self.node = node
  def run(self):
    all_done = 0
    while not all_done:
      try:
        job = self.job_queue.get(0)
        time.sleep(random.randint(5000,6000) / 1000.0)	# sleep random time
        single_thread(self.node, job)
      except Queue.Empty:
        all_done = 1
  pass

def single_thread(node,job):
  (job_id,job_content) = job
  logging.info(" %s->%s:%s" % (node, job_id, job_content))
  try:
    singleres = commands.getoutput(''' ssh %s " cd /cs/taatto/group/urenzyme/workspace/molecular_classification/data/preprocessing_codes; nohup matlab -nodisplay -nodesktop -nojvm -r 'compute_graph_kernels %s'  "  ''' % (node,job_content))
    logging.info(" %s-|%s" % (node, job_id))
  except:
    logging.info(" %s-<%s" % (node, job_id))
    job_queue.put((job))
  pass


def compute_graph_kernels_in_parallel():
  cluster = get_free_nodes()[0]
  kernelnamelist =  ['lRWkernel','WL',  'WLedge',  'WLspdelta',  'RGkernel1',  'l3graphletkernel',  'untilpRWkernel4',  'untilpRWkernel6',  'untilpRWkernel8',  'untilpRWkernel10',  'spkernel',  'SPkernel',  'RWkernel',  'gestkernel3',  'gestkernel4',  'connectedkernel3',  'connectedkernel4',  'connectedkernel5']
  # generate jobs and so on
  job_id = 0
  job_size = 1
  for kernelname in kernelnamelist:
    kernelresultfile = "../DTPNCI2015/results/ncicancer_kernel_graph_%s" % (kernelname)
    if os.path.exists(kernelresultfile):
      continue
    job_id = job_id + 1
    job_content = kernelname
    job_queue.put((job_id, job_content))
  logging.info("Processing jobs ...")
  # processing jobs
  job_size = job_queue.qsize()
  logging.info("In total %d jobs" % job_size)
  loadpernode = 1 
  threads = []
  counter = 0
  for node in cluster:
    for i in range(loadpernode):
      t = Worker(job_queue, node)
      time.sleep(0.5)
      counter = counter +1
      if counter > job_size:
        break
      try:
        t.start()
        threads.append(t)
      except ThreadError:
        logging.warning("\t\tThread error!")
  for t in threads:
    t.join()
  pass




compute_graph_kernels_in_parallel()







