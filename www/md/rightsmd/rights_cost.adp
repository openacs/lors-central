<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<include src="../form-md-record/md-record"
    ims_md_id="@ims_md_id;noquote@"
/>

<hr>

<h3>Rights Metadata Cost</h3>
<blockquote>
  <table cellspacing="2" cellpadding="2" border="0" width="50%">
    <tr class="form-section">
      <th colspan="2">Rights Metadata</th>
    </tr>
    <tr class="form-section">
      <td class="form-section">Cost: </td>
      <td><listtemplate name= "d_ri_cost"></listtemplate></td>
    </tr>   

  </table>
</blockquote>
<p>

<h3>Add/Edit Rights Metadata Cost</h3>
<blockquote>
 <formtemplate id="rightsmd_cost" style="standard-lars"></formtemplate>
</blockquote>
