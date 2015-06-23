from SOAPpy import WSDL

thing = '379007'

wdsl = 'http://www.noncode.org/soap/soapserver.php?wsdl'
serv = WSDL.Proxy(wdsl);

results = serv.ncRNADetails(thing)
print results

results = serv.queryByRNA(thing)
print results

results = serv.queryByNucleotide(thing)
print results
results = serv.queryByReference(thing)
print results
results = serv.queryByClass(thing)
print results
results = serv.queryByLength(thing)
print results