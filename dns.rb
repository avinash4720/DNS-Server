def get_command_line_arguement
  if ARGV.empty?
    	puts "Usage: ruby lookup.rb <domain>"
    	exit
  end
  ARGV.first
end

domain=get_command_line_arguement
dns_raw=File.readlines("zone.txt")
dns_records={}
lookup_chain=[]
def parse_dns(files)
  temp_hash={}
  files.each do |each_record|
    	temp_array=[]
  	each_record.split(" , ").each do |element|
      		temp_array.push(element.strip)
    	end   
    	temp_hash[temp_array[1]]={"record type"=>temp_array[0],"destination"=>temp_array[2].to_s}
  end
  return temp_hash
end
def resolve(dns_records,lookup_chain,domain)
  if dns_records[domain].nil?
    	lookup_chain.push("not found")
    	return lookup_chain
  elsif(dns_records[domain]["record type"].to_s=="CNAME")
    	lookup_chain.push(dns_records[domain]["destination"].to_s)
    	resolve(dns_records,lookup_chain,dns_records[domain]["destination"])
  elsif(dns_records[domain]["record type"].to_s=="A")
    	lookup_chain.push(dns_records[domain]["destination"].to_s)
    	return lookup_chain
  end
end
dns_records=parse_dns(dns_raw)
lookup_chain=[domain]
lookup_chain=resolve(dns_records,lookup_chain,domain)
puts lookup_chain.join("=>")
