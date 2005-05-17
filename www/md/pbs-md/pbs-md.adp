<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<include src="../../lib/md-record-pbs"
    ims_md_id="@ims_md_id;noquote@"/>

  <table cellspacing="2" cellpadding="2" border="0" width="80%">
    <tr class="form-section">
      <th colspan="2">PBS Metadata</th>
    </tr>
    <tr class="form-section">
      <td class="form-section" width="20%">Program Title/Episode Title:</td>
      <td><listtemplate name= "d_gen_titles"></listtemplate></td>
    </tr>   

    <tr class="form-section">
     <td class="form-section" width="20%">PBS Curriculum Topics:</td>
     <td><listtemplate name= "d_gen_cata_pbs_ct"></listtemplate></td>
    </tr>

    <tr class="form-section">
     <td class="form-section" width="20%">PBS Subject Areas:</td>
     <td><listtemplate name= "d_gen_cata_pbs_sa"></listtemplate></td>
    </tr>

    <tr class="form-section">
     <td class="form-section" width="20%">#lorsm.Descriptions# </td>
     <td><listtemplate name= "d_gen_desc"></listtemplate></td>
    </tr>

    <tr class="form-section">
     <td class="form-section" width="20%">#lorsm.Keywords# </td>
     <td><listtemplate name= "d_gen_key"></listtemplate></td>
    </tr>   

    <tr class="form-section">
      <td class="form-section" width="20%">URL:</td>
      <td><listtemplate name= "d_te_loca"></listtemplate></td>
    </tr>   

    <tr class="form-section">
      <td class="form-section" width="20%">Grade Range:</td>
      <td><listtemplate name= "d_ed_cont"></listtemplate></td>
    </tr>   

    <tr class="form-section">
      <td class="form-section" width="20%">Resource Type</td>
      <td><listtemplate name= "d_ed_lrt"></listtemplate></td>
    </tr>   

  </table>


  

