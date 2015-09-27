printf '' >> ../run.pid
kill $(cat ../run.pid)
rm ../run.pid
