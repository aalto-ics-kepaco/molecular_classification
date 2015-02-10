



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
  logging.info(" %s->%s" % (node, job_id))
  try:
    #print("ssh -o StrictHostKeyChecking=no %s '/cs/fs/home/su/softwares/openbabel/bin/babel /cs/taatto/group/urenzyme/workspace/molecular_classification/data/structures/sdffiles/%s.sdf -ofpt -xfFP2 > /cs/taatto/group/urenzyme/workspace/molecular_classification/data/structures/FPfiles/%s.fp'" % (node,job_content,job_content))
    singleres = commands.getoutput("ssh -o StrictHostKeyChecking=no %s '/cs/fs/home/su/softwares/openbabel/bin/babel /cs/taatto/group/urenzyme/workspace/molecular_classification/data/structures/sdffiles/%s.sdf -ofpt -xfFP2 > /cs/taatto/group/urenzyme/workspace/molecular_classification/data/structures/FPfiles/%s.fp'" % (node,job_content,job_content))
    logging.info(" %s-|%s" % (node, job_id))
  except:
    logging.info(" %s-<%s" % (node, job_id))
    job_queue.put((job))
  pass


def compute_fingerprints_in_parallel():
  # cluster is a list of node in an interative cluster e.g. ['ukko001.hpc','ukko002.hpc']
  cluster = get_free_nodes()[0]
  #cluster = ['melkinkari']
  logging.info("Read in list of molecules ...")
  moleculelist = []
  fin = open('../DTPNCI2015/results/ncicancer_labels')
  for line in fin:
    moleculelist.append(line.strip())
  fppath = '../structures/FPfiles/'
  if not os.path.exists(fppath):
    os.makedirs(fppath)
  logging.info("Generate jobs ...")
  # generate jobs and so on
  job_id = 0
  job_size = 1
  for molecule in moleculelist:
    if os.path.exists("%s%s.fp" % (fppath,molecule)):
      continue
    job_id = job_id + 1
    job_content=molecule
    job_queue.put((job_id,job_content))
  logging.info("Processing jobs ...")
  # processing jobs
  job_size = job_queue.qsize()
  logging.info("In total %d jobs" % job_size)
  loadpernode = 8
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






compute_fingerprints_in_parallel()

