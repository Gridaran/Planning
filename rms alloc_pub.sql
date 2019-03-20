DECLARE
l_count NUMBER := 1;
cursor c_alloc is
select alloc_no from alloc_header where alloc_no in ('');
 Begin

for rec in c_alloc loop
delete from lm_alloc_details_published
where alloc_no = rec.alloc_no;

delete from lm_alloc_pub_info
where alloc_no = rec.alloc_no;

delete from lm_alloc_mfqueue
where alloc_no = rec.alloc_no;

insert into lm_alloc_pub_info( alloc_no,
                                     initial_approval_ind,
                                     thread_no,
                                     wh,
                                     physical_wh,
                                     item,
                                     pack_ind,
                                     sellable_ind,
                                     published )
                            values ( rec.alloc_no,
                                     DECODE('A', 'A', 'Y', 'N'),
                                     MOD(rec.alloc_no, '5')+1,
                                     NULL,
                                     NULL,
                                     NULL,
                                     NULL,
                                     NULL,
                                    'N' );

insert into lm_alloc_mfqueue ( seq_no,
                                   alloc_no,
                                   to_loc,
                                   message_type,
                                   thread_no,
                                   family,
                                   custom_message_type,
                                   pub_status,
                                   transaction_number,
                                   transaction_time_stamp )
                          values ( l_count,
                                   rec.alloc_no,
                                   '',
                                   'AllocHdrMod',
                                   MOD(rec.alloc_no, '5')+1,
                                   'alloc',
                                   'N',
                                   'U',
                                   rec.alloc_no,
                                   SYSDATE);
l_count := l_count + 1;

end loop;
end; 