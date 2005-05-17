<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<include src="../../lib/md-record-pbs"
    ims_md_id="@ims_md_id;noquote@"
/>

<hr>

<h3>List of PBS Descriptions</h3>
<blockquote>
  <table cellspacing="2" cellpadding="2" border="0" width="50%">
    <tr class="form-section">
      <th colspan="2">General Descriptions</th>
    </tr>
    <tr class="form-section">
      <td class="form-section">Descriptions: </td>
      <td><listtemplate name= "d_gen_desc"></listtemplate></td>
    </tr>   

  </table>
</blockquote>
<p>

<h3>Add/Edit Description</h3>
<blockquote>
 <formtemplate id="generalmd_desc" style="standard-lars"></formtemplate>
</blockquote>
