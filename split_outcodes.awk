$1 != "id" {
  prev=file;
  split($2, f, " ");
  outcode = f[1]
  outcode1 = substr(outcode, 1, 1)
  outcode2 = substr(outcode, 2, 1)
  file="target/outcode/" outcode1 "/" outcode2 "/" outcode ".csv";
  if (prev!=file) close(prev);
  if (headers[file] != "done") {
    print "id,postcode,lat,lon" >> file;
    headers[file] = "done"
  }
  print $0 >> file;
}