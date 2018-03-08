
onpremise_bigip="/home/ansible/f5-sdmdc/onpremise_bigip"
azure_bigip="/home/ansible/f5-sdmdc/hackazon-iac"
dashboard="/home/ansible/f5-sdmdc/dashboard"


while test $# -gt 0; do
        case "$1" in
                -h|--help)
                        echo " "
                        echo "options:"
                        echo "-h, --help                show brief help"
                        echo "-op_apsvr_setup"
                        echo "-op_apsvr_remove"
                        echo "-op_attach_app_protection"
                        echo "-op_detach_app_protection"

                        exit 0
                        ;;
                -op_apsvr_setup)
                        shift
                        ansible-playbook $onpremise_bigip/sd-onprem_appsvr.yml -e state=present -vvv >> $dashboard/sdmdc_demo.log
                        ansible-playbook $onpremise_bigip/sd-onprem_create_dosprofile.yml -e state=present -vvv >> $dashboard/sdmdc_demo.log
                        ansible-playbook $onpremise_bigip/sd-onprem_createasmpolicy.yml -e state=present -vvv >> $dashboard/sdmdc_demo.log
                        ansible-playbook $onpremise_bigip/sd-onprem_creategslb.yml -e state=present -vvv >> $dashboard/sdmdc_demo.log
                        shift
                        ;;
                -op_apsvr_remove)
                        shift
                        ansible-playbook $onpremise_bigip/sd-onprem_appsvr.yml -e state=absent -vvv 
                        ansible-playbook $onpremise_bigip/sd-onprem_create_dosprofile.yml -e state=absent -vvv 
                        ansible-playbook $onpremise_bigip/sd-onprem_attachasmpolicy.yml -e state=absent -vvv 
                        ansible-playbook $onpremise_bigip/sd-onprem_createasmpolicy.yml -e state=absent -vvv 
                        ansible-playbook $onpremise_bigip/sd-onprem_creategslb.yml -e state=absent -vvv
                        shift
                        ;;
                -op_attach_app_protection)
                        shift
                        ansible-playbook $onpremise_bigip/sd-onprem_attachdosprofile.yml -e state=present -vvv >> $dashboard/sdmdc_demo.log
                        ansible-playbook $onpremise_bigip/sd-onprem_attachasmpolicy.yml -e state=present -vvv >> $dashboard/sdmdc_demo.log
                        shift
                        ;;
                -op_detach_app_protection)
                        shift
                        ansible-playbook $onpremise_bigip/sd-onprem_attachdosprofile.yml -e state=absent -vvv >> $dashboard/sdmdc_demo.log
                        ansible-playbook $onpremise_bigip/sd-onprem_attachasmpolicy.yml -e state=absent -vvv >> $dashboard/sdmdc_demo.log
                        shift
                        ;;
                -op_update_gslb_azure)
                        shift
                        ansible-playbook $onpremise_bigip/sd-onprem_updategslb.yml -e state=present --extra-vars "new_hackazon_ip=`tail -1 $dashboard/azure_ip.txt`" -vvv >> $dashboard/sdmdc_demo.log
                        shift
                        ;;
                -azure_demo_setup)
                        shift
                        ansible-playbook -i $azure_bigip/azure/azure_rm.py $azure_bigip/azure/main.yml -vvv >> $dashboard/sdmdc_demo.log
                        shift
                        ;;
                -aws_demo_setup)
                        shift
                        tower-cli job launch --job-template=7 -e biplic=BKGGB-UTFKP-DGIVC-JECGT-MOUCQCF -e host=lh1 -v >> $dashboard/sdmdc_demo.log
                        shift
                        ;;
                -aws_scale_out)
                        shift
                        echo $0
                        echo $1
                        tower-cli job launch --job-template=10 -e desired=$1 -v  >> $dashboard/sdmdc_demo.log
                        shift
                        ;;
                -aws_attach_app_protection)
                        shift
                        tower-cli job launch --job-template=14 -v  >> $dashboard/sdmdc_demo.log
                        shift
                        ;;
                *)
                        break
                        ;;
        esac
done