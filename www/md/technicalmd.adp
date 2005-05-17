<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<include src="../lib/md-record"
    ims_md_id="@ims_md_id;noquote@"/>

  <table cellspacing="2" cellpadding="2" border="0">
    <tr class="form-section">
      <th colspan="2">#lorsm.Technical_Metadata#</th>
    </tr>

    <tr class="form-section">
      <td class="form-section">#lorsm.Formats# </td>
      <td><listtemplate name= "d_te_form"></listtemplate></td>
    </tr>   
 
    <tr class="form-section">
      <td class="form-section">#lorsm.Size# </td>
      <td><listtemplate name= "d_te_size"></listtemplate></td>
    </tr>   
 
    <tr class="form-section">
      <td class="form-section">#lorsm.Locations# </td>
      <td><listtemplate name= "d_te_loca"></listtemplate></td>
    </tr>   

    <tr class="form-section">
      <td class="form-section">#lorsm.Requirements# </td>
      <td><listtemplate name= "d_te_req"></listtemplate></td>
    </tr>   

    <tr class="form-section">
      <td class="form-section">#lorsm.Installation_Remarks# </td>
      <td><listtemplate name= "d_te_inst"></listtemplate></td>
    </tr> 

    <tr class="form-section">
      <td class="form-section">#lorsm.lt_Other_Platform_Requir# </td>
      <td><listtemplate name= "d_te_otr"></listtemplate></td>
    </tr> 

    <tr class="form-section">
      <td class="form-section">#lorsm.Duration#</td>
      <td><listtemplate name= "d_te_dur"></listtemplate></td>
    </tr> 

  </table>

